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
# Generates the table of content (TOC) for all the markdown files where a TOC
# should be generated.
#
# Files with a table of contants contain an HTML comment '<!-- DOCTOC INCLUDE -->'
#
# The TOC is generated using the DOCTOC library of nodejs, and placed either at
# the top of the file, or between the HTML comments:
#   - START doctoc generated
#   - END doctoc generated
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script and the directory of the project
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_ROOT=$(realpath -m --relative-to=. ${SCRIPT_DIR}/../../..)

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory where the binary of npm packages are locally installed.
#
NPM_BIN_DIR="$(npm bin)"
NPM_BIN_DIR=$(realpath -m --relative-to=. ${NPM_BIN_DIR})

# ##############################################################################
# ##############################################################################
# ## SCRIPT START ##############################################################
# ##############################################################################
# ##############################################################################

# ##############################################################################
#
# Load the dependencies of this script
#
source "${SCRIPT_DIR}/../../git/.tools/ignored_dirs.bash"

# ##############################################################################
#
# Print an intro message.
#
echo "Updating the table of content of Markdown files..."

# ##############################################################################
#
# Search for the markdown files containing 'DOCTOC INCLUDE' and run the doctoc
# only on them.
#
doctoc_files=""
FIND_OPTS=$(find_gitignored_opts $PROJ_ROOT)
FIND_CMD="find \"$PROJ_ROOT\" -name \"*.md\" $FIND_OPTS"
for file in $(eval $FIND_CMD); do
  if [ -n "$(grep 'DOCTOC INCLUDE' $file)" ]; then
    doctoc_files="${doctoc_files} $file"
  fi
done

# ##############################################################################
#
# Run the doctoc util on found files (if at least one file was found)
#
if [ -n "$doctoc_files" ]; then
  TRACE=$("$NPM_BIN_DIR/doctoc" $doctoc_files --github | grep "will be updated" | awk -F '"' '{print $2}')
  for updatedFile in $TRACE; do
    # Strip the leading './' if any for a pretty print.
    if [[ "$updatedFile" =~ ^\./.*$ ]]; then
      updatedFile="${updatedFile:2}"
    fi
    echo -e "\tIN '$updatedFile'"
  done
fi

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo -e "\tFINISHED"
