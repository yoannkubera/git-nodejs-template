#!/bin/bash
#
# ==============================================================================
#
# MIT License
#
# Copyright (c) 2019 Yoann KUBERA
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# ==============================================================================
# ==============================================================================
# ==============================================================================
#
# Script called by maintainers during the initialization process of a new feature
# branch. It will automatically create the initial commit of the feature and push
# it on the remote repository.
#
# It has to be called after the creation of the local branch of the script, the
# creation of the "FEATURE.md" and the call of the git add command.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script and the directory of the project
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Prints a new feature branch creation failure message and ends the script.
#
function manage_script_failure {
  echo "ERROR: Failed to create the new feature branch."
  echo
  exit 1
}

# ##############################################################################
# ##############################################################################
# ## SCRIPT START ##############################################################
# ##############################################################################
# ##############################################################################

# ##############################################################################
#
# Print an intro message.
#
echo
echo "=============== STARTING A REMOTE FEATURE BRANCH CREATION ==================================="
echo

# ##############################################################################
#
# Load the script dependencies
#
echo -e "\t- Loading dependencies"
source "${SCRIPT_DIR}/../.tools/io.bash"
source "${SCRIPT_DIR}/.tools/commit.bash"
source "${SCRIPT_DIR}/.tools/feature-branches.bash"

# ##############################################################################
#
# Check that the FEATURE.md file exists.
#
echo -e "\t- Checking the feature descriptor file..."
check_feature_file
if ! [ -f "${FEATUREMD_PATH}" ]; then
  manage_script_failure
fi

# ##############################################################################
#
# Check that the feature branch is provided in the file.
#
FEATURE_BRANCH=$(read_feature_branch_name)
if [ "$?" -ne "0" ]; then
  manage_script_failure
fi

# ##############################################################################
#
# Check that the branch at least locally exists
#
check_feature_branch_existing_locally "$FEATURE_BRANCH"
if [ "$?" -ne "0" ]; then
  manage_script_failure
fi

# ##############################################################################
#
# Check that the feature name is provided in the file.
#
FEATURE_NAME=$(read_feature_name)
if [ "$?" -ne "0" ]; then
  manage_script_failure
fi

# ##############################################################################
#
# Print the information on screen.
#
echo -e "\t- Got the information:"
echo -e "\t- \tThe feature branch is '${FEATURE_BRANCH}'"
echo -e "\t- \tThe feature name is '${FEATURE_NAME}'"

# ##############################################################################
#
# Ask if the creation should proceed.
#
confirm_info
CONFIRMING="$?"
if [ "$CONFIRMING" -ne 0 ]; then
  echo "The user canceled the creation."
  manage_script_failure
fi

# ##############################################################################
#
# Check that the branch name is accepted as a new feature branch
#
echo -e "\t- Checking the validity of the branch name..."
if ! [[ "${FEATURE_BRANCH}" =~ ^dev\- ]];then
  >&2 echo "ERROR: '${FEATURE_BRANCH}' is not a valid feature branch name!"
  >&2 echo "ERROR: The name should start with 'dev-'!"
  manage_script_failure
fi

exit 1

# ##############################################################################
#
# Check that the branch does not exists on remotes
#
echo -e "\t- Checking the current state of the project..."
git_branch_exists_remotely "$FEATURE_BRANCH"
if [ "$?" -eq "0" ]; then
  >&2 echo "ERROR: The branch '$FEATURE_BRANCH' already exists remotely!"
  manage_script_failure
fi

# ##############################################################################
#
# Check that we are in the appropriate feature branch
#
CURRENT_BRANCH="$(current_branch_name)"
if [ "$CURRENT_BRANCH" != "$FEATURE_BRANCH" ]; then
  >&2 echo "ERROR: The current branch '$CURRENT_BRANCH' does not correspond to the branch from the feature description!"
  manage_script_failure
fi

# ##############################################################################
#
# Check that there is something to commit and that the project is in a commit
# ready state.
#
check_commit_readiness
if [ "$?" -ne "0" ]; then
  manage_script_failure
fi

# ##############################################################################
#
# Commit the changes.
#
echo -e "\t- Committing locally..."
MESSAGE="Starting the development of the feature: ${FEATURE_NAME}"
git commit -m "$MESSAGE" &> /dev/null
if [ "$?" -ne 0 ]; then
  >&2 echo "ERROR: Failed to commit the changes!"
  manage_script_failure
fi

# ##############################################################################
#
# Push the branch on the remote repository
#
echo -e "\t- Pushing the new branch on the remote..."
git push -u origin "${FEATURE_BRANCH}" &> /dev/null
OBTAINED_CODE="$?"
if [ "$OBTAINED_CODE" -ne 0 ]; then
  >&2 echo "ERROR: Failed to push the branch on the remote (got code $OBTAINED_CODE)!"
  manage_script_failure
fi

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo
echo "=============== END OF THE A REMOTE FEATURE BRANCH CREATION ================================="
echo
