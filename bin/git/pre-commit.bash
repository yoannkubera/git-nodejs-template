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
# Script that should be automatically called as a pre-commit hook by git. It
# performs integrity and content checks on the project before allowing the
# commit.
#
# This script runs all the scripts from the `bin/git/pre-commit` directory, in
# the order of their numeric prefix.
#
# ==============================================================================

# Identify the directory of this script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Identify the directory where the custom pre-commit scripts are stored.
PRECOMMIT_SCRIPTS_DIR="${SCRIPT_DIR}/.pre-commit"
PRECOMMIT_SCRIPTS_DIR="$(realpath -m --relative-to=. ${PRECOMMIT_SCRIPTS_DIR})"

# Print an intro message.
echo
echo "=============== STARTING THE PRE-COMMIT CHECKS ====================================="
echo

# Look for bash scripts inside the directory (in the alphabetical order)
for file_basename in $(find "${PRECOMMIT_SCRIPTS_DIR}" -maxdepth 1 -type f -name "*.bash" -exec basename {} \; | sort -n); do
  # Rebuild the path of the file from the obtained name.
  FILE_PATH="${PRECOMMIT_SCRIPTS_DIR}/${file_basename}"
  # Run the script
  bash "$FILE_PATH"
done

# Print an ending message.
echo
echo "=============== END OF THE PRE-COMMIT CHECKS ======================================"
echo
