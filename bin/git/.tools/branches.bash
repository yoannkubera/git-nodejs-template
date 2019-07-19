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
# Bash script providing helper functions related to git branches.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the absolute path of the directory hosting this script.
#
GIT_TOOLS_BRANCHES_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the root directory of the project.
#
PROJ_ROOT=$(realpath -m --relative-to=. ${GIT_TOOLS_BRANCHES_SCRIPTDIR}/../../..)

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Checks if a git branch exists locally or not.
#
# ARGUMENT 1: The name of the branch to check
#
# RETURN STATUS:
#     0 If the branch exists
#     1 Else
#
function git_branch_exists_locally {
  (cd ${PROJ_ROOT} && git rev-parse --verify "$1" &> /dev/null)
  if [ "$?" -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Checks if a git branch exists remotely or not.
#
# ARGUMENT 1: The name of the branch to check
#
# RETURN STATUS:
#     0 If the branch exists
#     1 Else
#
function git_branch_exists_remotely {
  (cd ${PROJ_ROOT} && git branch -r|grep -w "$1" &> /dev/null)
  if [ "$?" -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Gets the name of the current branch.
#
# RETURNS (echo): The name of the current branch
#
# RETURN STATUS:
#     0 If the project is managed by git
#     1 Else
#
function current_branch_name {
  (cd ${PROJ_ROOT} && git branch &> /dev/null)
  if [ "$?" -eq 0 ]; then
    (cd ${PROJ_ROOT} && git branch 2> /dev/null | grep \* | cut -d ' ' -f2)
  else
    >&2 echo "ERROR: '${PROJ_ROOT}' is not a git repository!"
    return 0
  fi
}
