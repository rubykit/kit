#!/usr/bin/env bash

set -e

exists()      { command -v "$1" >/dev/null 2>&1; }
fn_readlink() { if exists greadlink ; then greadlink "$@" ; else readlink "$@" ; fi; }


# SETUP: please have a look at this! -------------------------------------------

# The source branch. Change this when working on this script.
branch_master='master'
# The target branch.
branch_documentation='gh-pages'

# Kit directory.
kit_dir=$(fn_readlink -f "$(dirname $(fn_readlink -f "${0}"))/..")
# Documentation build directory.
documentation_build_dir="${kit_dir}/docs/dist"

# The list of gems we want to generate documentation for.
# Add target gems here.
declare -A documentation_targets=(
  ["kit"]=$kit_dir
  ["kit-api"]="${kit_dir}/libraries/kit-api"
  ["kit-contract"]="${kit_dir}/libraries/kit-contract"
  ["kit-doc"]="${kit_dir}/libraries/kit-doc"
  ["kit-organizer"]="${kit_dir}/libraries/kit-organizer"
  ["kit-pagination"]="${kit_dir}/libraries/kit-pagination"
  ["kit-router"]="${kit_dir}/libraries/kit-router"
)
#typeset -p documentation_targets


# SAFETY CHECKS ----------------------------------------------------------------

# Usage
usage() {
  cat <<EOM
  GENERATE ALL DOCUMENTATION
    $(basename $0) generate-documentation

  GENERATE GH PAGE COMMIT
    $(basename $0) create-gh-pages-commit
EOM
    exit
}

# Ensure we are on a clean install.
ensure_clean_install() {
  echo "This script generates the documentation to be published on the project GitHub pages."
  echo "PLEASE use a clean copy of the repo to run this!"
  echo "We are currently in \`${kit_dir}\`"
  read -r -p "Is this a clean install? [y/N] " response
  if [[ "${response,,}" =~ ^(yes|y)$ ]]; then
    echo "  Good."
  else
    echo "  Aborted. Please run \`git clone git@github.com:rubykit/kit.git\` somewhere clean before running this."
    exit
  fi
}

# Clean documentation build dir (should be done in the rake task too but let's be sure).
clean_documentation_build_dir() {
  documentation_build_dir_content="$documentation_build_dir/*"
  read -r -p $'\e[31mAbout to rm -rf `'$documentation_build_dir_content$'`, does the documentation build dir looks right? [y/N] \e[0m' response
  if [[ "${response,,}" =~ ^(yes|y)$ ]]; then
    rm    -rf $documentation_build_dir_content
    mkdir -p  $documentation_build_dir
  else
    echo "  Aborted."
    exit
  fi
}

# GENERATE DOCUMENTATION FILES -------------------------------------------------

# Generate documentation for each gem.
generate_documentation() {
  for documentation_target_name in "${!documentation_targets[@]}"; do
    documentation_target_src_path=${documentation_targets[$documentation_target_name]}
    documentation_target_dst_path="${documentation_build_dir}/${documentation_target_name}"

    echo "  Gem: ${documentation_target_name} (src: \`${documentation_target_src_path}\`, dst: \`${documentation_target_dst_path}\`)"

    cd  $kit_dir
    git checkout --quiet $branch_master
    cd  $documentation_target_src_path

    # Create the doc directories for this gem
    mkdir -p $documentation_target_dst_path

    bundle install
    KIT_DOC_OUTPUT_DIR_BASE=$documentation_target_dst_path bundle exec rake documentation:all_versions:generate
  done

  # Go back to the initial state
  cd  $kit_dir
  git checkout --quiet $branch_master

  # Add the top level `index.html`
  bundle exec rake documentation:all_versions:generate:global_assets
}

# GITHUB PAGES BRANCH SETUP ----------------------------------------------------

# Recreate the documentation branch
create_gh_pages_commit() {
  if [ -n "`git show-ref refs/heads/$branch_documentation`" ]; then
    git branch -d $branch_documentation
  fi
  git checkout -b $branch_documentation

  # Move documentation files to top level
  documentation_files=$(cd ${documentation_build_dir}; ls -1)
  mv ${documentation_build_dir}/* .
  git add $documentation_files

  # Move CNAME file for github as we are about to force push
  git mv ./docs/CNAME .

  # Commit the generated files.
  git commit -m "KIT DOCUMENTATION - generated on `date '+%F@%H-%M-%S'`"

  echo "We should be good to go! Please do check that:"
  echo "  - You are currently on the expected documentation branch:"
  echo "     Expected: \`$branch_documentation\`, Current: \``git rev-parse --abbrev-ref HEAD`\` (if it's not \`gh-pages\`, please double check!)"
  echo "  - Have look at the last commit that was auto-generated , run: \`git log --name-status HEAD^..HEAD
  \` we should be in a clean state."
  echo "  - If everything looks good, run \`git push --force origin $branch_documentation:$branch_documentation\`"
}


# EXECUTION --------------------------------------------------------------------

[ -z $1 ] && { usage; }

if [ "${1}" == "generate-documentation" ]; then
  ensure_clean_install
  clean_documentation_build_dir
  generate_documentation
elif [ "${1}" == "create-gh-pages-commit" ]; then
  ensure_clean_install
  create_gh_pages_commit
else
  usage
fi
