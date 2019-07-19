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
# Bash script providing helper functions related to git commit related commands.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the absolute path of the directory hosting this script.
#
GIT_TOOLS_COMMIT_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the root directory of the project.
#
PROJ_ROOT=$(realpath -m --relative-to=. ${GIT_TOOLS_COMMIT_SCRIPTDIR}/../../..)

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Gets a description of the unstaged changes made in the tracked file of the
# project.
#
# RETURNS (echo):
#     Some text describing the unstaged changes
#     Nothing if there are no unstaged changes
#
function get_local_unstaged_changes {
    (cd $PROJ_ROOT && git diff --exit-code)
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Gets a description of the staged changes made in the tracked file of the
# project and are yet to be committed.
#
# RETURNS (echo):
#     Some text describing the uncommitted changes
#     Nothing if there are no uncommitted changes
#
function get_local_uncommited_changes {
  (cd $PROJ_ROOT && git diff --cached --exit-code)
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Gets the list of the untracked files of the project that are not ignored.
#
# RETURNS (echo):
#     Some text describing the untracked files
#     Nothing if there are no untracked files
#
function get_local_untracked_files {
  (cd $PROJ_ROOT && git ls-files --other --exclude-standard --directory)
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Checks if the project is in a commit ready state, i.e. if there are no unstaged
# or untracked changes, and there are uncommited changes.
#
# RETURN STATUS:
#     0 If the project is ready to be committed
#     1 Else
#
function check_commit_readiness {
  if [ -n "$(get_local_unstaged_changes)" ]; then
    >&2 echo "ERROR: The project has unstaged changes and cannot be committed!"
    return 1
  fi
  if [ -n "$(get_local_untracked_files)" ]; then
    >&2 echo "ERROR: The project has new untracked files and cannot be committed!"
    return 1
  fi
  if [ -z "$(get_local_uncommited_changes)" ]; then
    >&2 echo "ERROR: The project has nothing to commit!"
    return 1
  fi
  return 0
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Checks if the project has nothing to commit.
#
# RETURN STATUS:
#     0 If the project has nothing to commit
#     1 Else
#
function check_nothing_to_commit {
  if [ -n "$(get_local_unstaged_changes)" ]; then
    >&2 echo "ERROR: The project has unstaged changes!"
    return 1
  fi
  if [ -n "$(get_local_untracked_files)" ]; then
    >&2 echo "ERROR: The project has new untracked files!"
    return 1
  fi
  if [ -n "$(get_local_uncommited_changes)" ]; then
    >&2 echo "ERROR: The project has staged but uncommited changes!"
    return 1
  fi
  return 0
}
