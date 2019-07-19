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
# Bash script providing helper functions related to the feature branches.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the absolute path of the directory hosting this script.
#
GIT_TOOLS_FEATUREBRANCHES_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# -- DEPENDENCIES --------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Load the script dependencies.
#
source "${GIT_TOOLS_FEATUREBRANCHES_SCRIPTDIR}/branches.bash"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The path to the FEATURE.md file.
#
FEATUREMD_BASENAME="FEATURE.md"
FEATUREMD_PATH="${PROJ_ROOT}/${FEATUREMD_BASENAME}"

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Checks that the FEATURE.md file exists.
#
# RETURN STATUS:
#     0 If the file exists
#     1 Else. An error message is printed.
#
function check_feature_file {
  if ! [ -f "${FEATUREMD_PATH}" ]; then
    >&2 echo "ERROR: Cannot find the file '${FEATUREMD_BASENAME}' where the new feature should be described."
    return 1
  fi
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Checks if a local feature branch having the provided name exists.
#
# ARGUMENT 1: The name of the branch to check.
#
# RETURN STATUS:
#     0 If the branch exists
#     1 Else. An error message is printed.
#
function check_feature_branch_existing_locally {
  git_branch_exists_locally "$1"
  if [ "$?" -ne 0 ]; then
    >&2 echo "ERROR: The declaration of the feature branch in the '${FEATUREMD_BASENAME}' file is incorrect!"
    >&2 echo "ERROR: The feature branch '$1' does not exist!"
    return 1
  fi
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Reads the name of the feature branch from the local FEATURE.md file.
#
# RETURNS (echo): The name of the feature branch
#
# RETURN STATUS:
#     0 If the name was found
#     1 Else. An error message is printed.
#
function read_feature_branch_name {
  FEATURE_BRANCH=$(sed -n -e 's/^<!--[[:space:]]*branch:\(.*\)-->/\1/p' "${FEATUREMD_BASENAME}" | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//')
  if [ -z "${FEATURE_BRANCH}" ]; then
    >&2 echo "ERROR: Cannot find the declaration of the feature branch in the '${FEATUREMD_BASENAME}' file!"
    >&2 echo "ERROR: The file should contain a '<!-- branch: NAME -->' like line identifying the branch."
    return 1
  else
    echo "$FEATURE_BRANCH"
  fi
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Reads the name of the feature from the local FEATURE.md file.
#
# RETURNS (echo): The name of the branch
#
# RETURN STATUS:
#     0 If the name was found
#     1 Else. An error message is printed.
#
function read_feature_name {
  FEATURE_NAME=$(sed -n -e 's/^<!--[[:space:]]*name:\(.*\)-->/\1/p' "${FEATUREMD_BASENAME}" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
  if [ -z "${FEATURE_NAME}" ]; then
    >&2 echo "ERROR: Cannot find the declaration of the feature name in the '${FEATUREMD_BASENAME}' file!"
    >&2 echo "ERROR: The file should contain a '<!-- name: NAME -->' like line identifying the name."
    return 1
  else
    echo "$FEATURE_NAME"
  fi
}
