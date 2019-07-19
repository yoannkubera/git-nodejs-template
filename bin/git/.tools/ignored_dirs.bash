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
# Bash script providing helper functions related to git for the commands defined
# in the "bin/" directory of the project.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Identify the absolute path of the directory hosting this script.
GIT_TOOLS_IGNORED_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Builds options for the find command that will exclude everything identified in
# the '.gitignore' file.
#
# IMPORTANT NOTE: This function won't check if the provided path (as an argument)
#                 will lead to an inappropriate directory. We assume that the
#                 user has checked it beforehands.
#
# ARGUMENT 1      The path towards the root of the project, expressed relatively
#                 to the directory where the search is made. Note that in the case
#                 of the current directory, the value has to be '.' or './'
#
# RETURNS (echo)  The options for the find command excluding what is identified
#                 in the '.gitignore' file (as well as file from the '.git/'
#                 directory).
#
# FAILURES        1) If the argument is empty or is not an appropriate path.
#                 2) If an expression from the '.gitignore' file could not be
#                   properly parsed.
#
function find_gitignored_opts {
  # Identify the path towards the gitignore file.
  GITIGNORE_PATH="${GIT_TOOLS_IGNORED_SCRIPTDIR}/../../../.gitignore"
  # Check the argument of the function: It should exist and model a valid unix
  # path.
  if [ -z "$1" ] || ! [[ "$1" =~ ^/?[a-zA-Z_\.\-]+(/[a-zA-Z_\.\-]+)*/?$ ]]; then
    >&2 echo -e "ERROR: The reference path '$1' is invalid."
    return 1
  fi
  # Format the reference path to that it does not end with a slash.
  REF_PATH="$1"
  if [[ "$REF_PATH" =~ ^.*/$ ]]; then
    REF_PATH="${REF_PATH%?}"
  fi
  # Intialize the returned value to the git specific directory.
  FIND_OPTS="-not -path \"$REF_PATH/.git/*\""
  # Read the gitignore file.
  while read -r line; do
    # If the line is not a comment, not empty and contains no critical characters,
    # it is used as an exclusion item for find.
    if [[ "$line" =~ ^[a-zA-Z0-9_\-\./:\\\*]+$ ]]; then
      # If the line contains no '/' characters, then it can model both a file name
      # pattern or a director name pattern. Therefore, both have to be added.
      if [[ "$line" =~ ^[^/]*$ ]]; then
        FIND_OPTS="${FIND_OPTS} -not -name \"$line\" -not -path \"${REF_PATH}/$line/*\""
      else
      # Else, the line is assumed to model an excluded path from the root.
        # First check if the path is pre-fixed with './'. If so, remove it before
        # the proper prefix is added.
        CHECKED_PATH="$line"
        if ! [[ "$CHECKED_PATH" =~ ^\./.*$ ]]; then
          CHECKED_PATH="${REF_PATH}/$CHECKED_PATH"
        fi
        # Then create a rule based on that path
        if [[ "$line" =~ ^.*\*$ ]]; then
          # If the line models a path and ends with a star, then use it as is in the expression.
          FIND_OPTS="${FIND_OPTS} -not -path \"$CHECKED_PATH\""
        elif [[ "$line" =~ ^.*/$ ]]; then
          # If the line models a path and ends with a "/", add a star to match any file under it.
          FIND_OPTS="${FIND_OPTS} -not -path \"$CHECKED_PATH*\""
        else
          # Else, the excluded paths should be the line (if the rule models the
          # full path of a file) and the line with a "/*" post fix (if the rule
          # models a directory).
          FIND_OPTS="${FIND_OPTS} -not -path \"$CHECKED_PATH\" -not -path \"$CHECKED_PATH/*\""
        fi
      fi
    # If the line is not a comment, inform that it is ignored and throw an error.
    elif [[ "$line" =~ ^[^\#].*$ ]]; then
      >&2 echo "ERROR: The '.gitignore' file contains an unsupported expression:"
      >&2 echo -e "\t$line"
      exit 1
    fi
  done < "${GITIGNORE_PATH}"
  # "Return" the expected value.
  echo $FIND_OPTS
}
