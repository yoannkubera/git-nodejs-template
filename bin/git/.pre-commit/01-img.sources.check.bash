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
# Checks that the origin of all the images of the project are identified in a
# sources.md file.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script and the directory of the project
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_ROOT=$(realpath -m --relative-to=. ${SCRIPT_DIR}/../../..)

# ##############################################################################
# ##############################################################################
# ## SCRIPT START ##############################################################
# ##############################################################################
# ##############################################################################

# ##############################################################################
#
# Load the dependencies of this script
#
source "${SCRIPT_DIR}/../.tools/ignored_dirs.bash"

# ##############################################################################
#
# Print an intro message.
#
echo "Checking that the images sources are properly provided..."

# Loop over the files to identify the images.
FIND_OPTS=$(find_gitignored_opts $PROJ_ROOT)
FIND_CMD="find $PROJ_ROOT -type f $FIND_OPTS -exec file {} \\;"
for imgFile in $(eval $FIND_CMD | grep -o -P '^.+: \w+ image' | grep -o -P '^[^:]+'); do
  IMG_BASENAME=$(basename $imgFile)
  IMG_DIR=$(dirname $imgFile)
  IMG_DESCFILE="$IMG_DIR/sources.md"
  # If the file where the image should be described does not exist, throw an error.
  if [ ! -f "$IMG_DESCFILE" ]; then
    >&2 echo "ERROR: Cannot find the file '$IMG_DESCFILE' where the origin of the image '$IMG_BASENAME' should be identified."
    exit 1
  fi
  # If the image name is not found in the file, throw an error.
  if [ -z "$(grep -o -w $IMG_BASENAME $IMG_DESCFILE)" ]; then
      >&2 echo "ERROR: Cannot the origin of the image '$IMG_BASENAME' is not identified in file '$IMG_DESCFILE'!"
      exit 1
  fi
done

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo -e "\tFINISHED"
