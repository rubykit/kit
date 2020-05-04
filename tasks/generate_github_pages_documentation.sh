#!/usr/bin/env bash

set -e

documentation_build_dir='./docs/dist'
documentation_build_dir_content="$documentation_build_dir/*"

branch_master='master'
branch_documentation='gh-pages'

# Ensure we are on a clean install
echo "This script generates the documentation to be published on the project GitHub pages."
echo "PLEASE use a clean copy of the repo to run this!"
read -r -p "Is this the case? [y/N] " response
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

# For each version, checkout the tag, `bundle install` and generate doc.
for version in ${versions[@]}; do
  git checkout $version && bundle install && bundle exec rake documentation:yardoc:all
done

# At this point we should be in master but let's make sure
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
for version in ${versions[@]}; do
  if [ $version == $branch_master ]; then
    version='edge'
  fi

  cp  'docs_config.js' "./$version/"
  git add $version
done
git commit -m "PROJECT DOCUMENTATION - generated on `date '+%F@%H-%M-%S'`"

echo "We should be good to go! Please do check that:"
echo "  - You are currently on the expected documentation branch:"
echo "     Expected: \`$branch_documentation\`, Current: \``git rev-parse --abbrev-ref HEAD`\` (if it's not \`gh-pages\`, please double check!)"
echo "  - Have look at the last commit that was auto-generated."
echo "  - If everything looks good, run \`git push --force origin $branch_documentation:$branch_documentation\`"
