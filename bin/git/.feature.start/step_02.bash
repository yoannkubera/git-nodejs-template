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
# Second step of the start of a new feature, publishing the initialized new feature
# branch onto the remote.
#
# This script is called only if the user is in the 'current-candidate' branch,
# the branch is in sync with the remote (no pull required) and if the local branch
# contains a single unstage file FEATURE.md to commit.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script and the directory of the project
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_ROOT=$(realpath -m --relative-to=. ${SCRIPT_DIR}/../../..)

# https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
#UPSTREAM=${1:-'@{u}'}
#LOCAL=$(git rev-parse @)
#REMOTE=$(git rev-parse "$UPSTREAM")
#BASE=$(git merge-base @ "$UPSTREAM")
#
#if [ $LOCAL = $REMOTE ]; then
#    echo "Up-to-date"
#elif [ $LOCAL = $BASE ]; then
#    echo "Need to pull"
#elif [ $REMOTE = $BASE ]; then
#    echo "Need to push"
#else
#    echo "Diverged"
#fi
