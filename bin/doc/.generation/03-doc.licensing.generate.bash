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
# Generates the licensing information of the readme file (license name and URL,
# main contact and year) from the package.json file.
#
# These information are generated between the following HTML comments:
#     <!-- START licensing -->
#     <!-- END licensing -->
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script, the directory of the project and the path of the
# readme file.
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_ROOT=$(realpath -m --relative-to=. ${SCRIPT_DIR}/../../..)
README_PATH="${PROJ_ROOT}/Readme.md"
PACKAGEJSON_PATH="${PROJ_ROOT}/package.json"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The patterns used to identify where to put the badges in the readme file.
#
PATTERN_START="<!-- START licensing -->"
PATTERN_END="<!-- END licensing -->"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The path towards the data files used in the script (maps between ids and values).
#
LICENSE_NAMEDB_PATH="${SCRIPT_DIR}/badges/package_json.licenses.name.dat"
LICENSE_URLDB_PATH="${SCRIPT_DIR}/badges/package_json.licenses.url.dat"

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a text at the end of the licensing block in the readme file.
#
# ARGUMENT 1: The text to insert, compatible with a'/' separated sed expression.
#
function insert_at_end_of_licensing {
  # Insert the markdown text in the readme.
  sed -i "/^${PATTERN_END}/i $1" "$README_PATH"
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Gets the value associated to a specific key in one of the database files:
# OS_ICONDB_PATH, ENGINE_ICONDB_PATH, LICENSE_NAMEDB_PATH, LICENSE_URLDB_PATH
#
# ARGUMENT 1: The database file
# ARGUMENT 2: The key for which the value is retrieved (should be a word without
#             spaces).
# PRINTS:     The value corresponding to the key in the database file.
#
function get_db_val {
  if [ -n "$1" ] && [ -n "$2" ] && [ -f "$1" ]; then
    grep -w "^$2" "$1" | sed -e 's/^\w*\ *//'
  fi
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
echo "Updating the licensing info in the readme file..."

# ##############################################################################
#
# Remove the existing badges
#
sed -i "/${PATTERN_START}/,/${PATTERN_END}/{//!d}" "$README_PATH"

# ##############################################################################
#
# Parse the package.json file to extract the license name and information.
#
PROJ_LICENSE=$(jq -e -r '.license' ${PACKAGEJSON_PATH} 2> /dev/null)
# The badge is added only if the license key exists in the JSON file.
if [ "$?" -eq 0 ] && [ -n "$PROJ_LICENSE" ]; then
  # Only parse the license if it is a single name, and not an SPDX license
  # expression syntax version 2.0 string.
  if [ -z "$(echo $PROJ_LICENSE | grep -w 'OR')" ] && [ -z "$(echo $PROJ_LICENSE | grep -w 'AND')" ] && [ -z "$(echo $PROJ_LICENSE | grep -w 'WITH')" ]; then
    # Fetch the pretty name of the license (empty if none).
    LICENSE_NAME=$(get_db_val "$LICENSE_NAMEDB_PATH" "$PROJ_LICENSE")
    # If no entry was found among pretty names, the name is likely
    # itself a pretty name. Try to find the corresponding key, in order
    # to find the corresponding URL.
    LICENSE_KEY="$PROJ_LICENSE"
    if [ -z "${LICENSE_NAME}" ]; then
      LICENSE_NAME="$PROJ_LICENSE"
      LICENSE_KEY=$(cat "$LICENSE_NAMEDB_PATH" | grep -e "^[^[:space:]]*[[:space:]]*${PROJ_LICENSE}\$" | sed -n -e "s@\([^[:space:]]*\)[[:space:]]*${PROJ_LICENSE}\$@\1@p")
    fi
    # Fetch the URL towards the license web page (empty if none)
    LICENSE_URL=$(get_db_val "$LICENSE_URLDB_PATH" "$LICENSE_KEY")
  fi
else
  PROJ_LICENSE=""
fi

# ##############################################################################
#
# Insert the license information.
#
if [ -n "$PROJ_LICENSE" ]; then
  if [ -n "${LICENSE_URL}" ]; then
    insert_at_end_of_licensing "* _License:_ [${LICENSE_NAME}](${LICENSE_URL})"
  else
    insert_at_end_of_licensing "* _License:_ ${LICENSE_NAME}"
  fi
else
  echo -e "\tWARNING: Not generating licensing info in the documentation since it is a complex SPDX license expression syntax version 2.0"
  echo -e "\t\tSuch information should be manually added and updated after the '${PATTERN_END}' comment of the readme file."
fi

# ##############################################################################
#
# Parse the package.json file to extract the author identity
#
AUTHOR_DESC=$(jq -e -r '.author' ${PACKAGEJSON_PATH} 2> /dev/null)
# The author has to exist and cannot be empty
if [ "$?" -eq 0 ] && [ -n "$AUTHOR_DESC" ]; then
  # Extract the name of the author from the description
  PERSON_NAME="$(echo $AUTHOR_DESC | sed -n -e 's/\([^<(]*\).*/\1/p' | sed -e 's/[[:space:]]*$//')"
  # Get the current year.
  CURRENT_YEAR="$(date +%Y)"
  # Insert these info in the readme file.
  insert_at_end_of_licensing "* Copyright ${CURRENT_YEAR} © ${PERSON_NAME}"
else
  echo -e "\tWARNING: Not generating author licensing info"
fi

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo -e "\tFINISHED"
