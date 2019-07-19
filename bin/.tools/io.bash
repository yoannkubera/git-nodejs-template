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
# Bash script providing helper functions related to inputs and outputs.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the absolute path of the directory hosting this script.
#
TOOLS_IO_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Ask for a user confirmation for information.
#
# RETURN STATUS:
#     0 If there was a confirmation
#     1 Else
#
function confirm_info {
  echo
  read -p "Are you sure (y/n)? " REPLY
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}
