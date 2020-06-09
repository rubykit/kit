#!/usr/bin/env bash

set -e

# Reference: https://stackoverflow.com/a/21188136
get_abs_filename() {
  # $1 : relative filename
  if [ -d "$(dirname "$1")" ]; then
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
  fi
}

top_level_dir=`pwd`
documentation_build_dir=$(get_abs_filename './docs/dist')
documentation_build_dir_content="$documentation_build_dir/*"

# The source branch. Change this when working on this script.
#branch_master='master'
branch_master='chore/documentation-generation'
# The target branch.
branch_documentation='gh-pages'

# The list of gems we want to generate documentation for.
declare -A documentation_targets
documentation_targets=(["kit"]=$top_level_dir ["kit-api"]="libraries/kit-api")

# Ensure we are on a clean install
echo "This script generates the documentation to be published on the project GitHub pages."
echo "PLEASE use a clean copy of the repo to run this!"
echo "We are currently in \`${top_level_dir}\`"
read -r -p "Is this a clean install? [y/N] " response
if [[ "${response,,}" =~ ^(yes|y)$ ]]; then
  echo "  Good."
else
  echo "  Aborted. Please run \`git clone git@github.com:rubykit/kit.git\` somewhere clean before running this."
  exit
fi

# Get all tags to generate the doc for.
mapfile -t versions < <(git tag -l "v*" --sort=-v:refname)
declare -a versions
versions+=($branch_master)

# Clean documentation build dir (should be done in the rake task too but let's be sure)
read -r -p "About to rm -rf \`$documentation_build_dir_content\`, does the documentation build dir looks right? [Y/n] " response
if [[ "${response,,}" =~ ^(yes|y)$ ]]; then
  rm    -rf $documentation_build_dir_content
  mkdir -p  $documentation_build_dir
else
  echo "  Aborted."
  exit
fi

# For each version, checkout the tag, and generate doc for each gem.
for version in ${versions[@]}; do
  cd $top_level_dir
  git checkout $version

  echo "  Version: ${version}"

  # For each gem
  for documentation_target in "${!documentation_targets[@]}"; do
    documentation_target_src_path=${documentation_targets[$documentation_target]}
    documentation_target_dst_path="${documentation_build_dir}/${documentation_target}"

    echo "    Gem: ${documentation_target} (src: \`${documentation_target_src_path}\`, dst: \`${documentation_target_dst_path}\`)"

    mkdir -p $documentation_target_dst_path

    cd $top_level_dir
    cd $documentation_target_src_path
    bundle install && KIT_DOC_OUTPUT_DIR=$documentation_target_dst_path bundle exec rake documentation:yardoc
  done
done

# Go back to the top level dir, on master.
cd $top_level_dir
git checkout $branch_master

# Add the top level `index.html` and `doc_config.js`
bundle exec rake documentation:generate_global_dist_assets

# Recreate the documentation branch
if [ -n "`git show-ref refs/heads/$branch_documentation`" ]; then
  git branch -d $branch_documentation
fi
git checkout -b $branch_documentation

cp -r $documentation_build_dir_content .

# Generate CNAME file for github as we are about to force push
echo 'docs.rubykit.org' > 'CNAME'

# Add top level files + version directories
git add 'CNAME'
git add 'index.html'
git add 'docs_config.js'

# For each combo gem/version
for documentation_target in "${!documentation_targets[@]}"; do
  for version in ${versions[@]}; do
    if [ $version == $branch_master ]; then
      version='edge'
    fi

    cp 'docs_config.js' "./$documentation_target/$version/"
  done

  git add $documentation_target_path
done

git commit -m "PROJECT DOCUMENTATION - generated on `date '+%F@%H-%M-%S'`"

echo "We should be good to go! Please do check that:"
echo "  - You are currently on the expected documentation branch:"
echo "     Expected: \`$branch_documentation\`, Current: \``git rev-parse --abbrev-ref HEAD`\` (if it's not \`gh-pages\`, please double check!)"
echo "  - Have look at the last commit that was auto-generated."
echo "  - If everything looks good, run \`git push --force origin $branch_documentation:$branch_documentation\`"
