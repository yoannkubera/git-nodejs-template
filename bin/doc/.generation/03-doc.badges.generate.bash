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
# Generates the badges displayed at the top of the readme.md file.
#
# Badges are generated between the following HTML comments:
#     <!-- START badges-list -->
#     <!-- END badges-list -->
#
# This script relies on some information extracted from the GitHub help and the
# simple icons site:
#   - bin/git/.tools/package_json.icons.engines.dat
#   - bin/git/.tools/package_json.icons.os.dat
#   - bin/git/.tools/package_json.licenses.name.dat
#   - bin/git/.tools/package_json.licenses.url.dat
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
# The path towards the data files used in the script (maps between ids and values).
#
OS_ICONDB_PATH="${SCRIPT_DIR}/badges/package_json.icons.os.dat"
ENGINE_ICONDB_PATH="${SCRIPT_DIR}/badges/package_json.icons.engines.dat"
LICENSE_NAMEDB_PATH="${SCRIPT_DIR}/badges/package_json.licenses.name.dat"
LICENSE_URLDB_PATH="${SCRIPT_DIR}/badges/package_json.licenses.url.dat"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The patterns used to identify where to put the badges in the readme file.
#
PATTERN_START="<!-- START badges-list -->"
PATTERN_END="<!-- END badges-list -->"

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a new badge at the end of the badges list in the Readme file.
#
# ARGUMENT 1:   The label of the badge
# ARGUMENT 2:   The message of the badge
# ARGUMENT 3:   The color of the badge, as defined by the https://shields.io/ website
# ARGUMENT 4:   [Optionnal] The logo used in the badge. Its possible values are
#               available on the website https://simpleicons.org/
#               If left empty, no logo is used.
# ARGUMENT 5:   [Optionnal] The URL of the redirection done if a user clicks on
#               the badge.
#
function insert_badge {
  # Create the opening part of the markdown text of the badge
  MARKDOWN_TEXT="https://img.shields.io/static/v1.svg?"
  # Include the badge label in the markdown text (left part)
  BADGE_LABEL="$(urlencode $1)"
  MARKDOWN_TEXT="${MARKDOWN_TEXT}label=${BADGE_LABEL}"
  # Include the badge message in the markdown text (right part)
  BADGE_MESSAGE="$(urlencode $2)"
  MARKDOWN_TEXT="${MARKDOWN_TEXT}&message=${BADGE_MESSAGE}"
  # Include the badge color in the markdown text
  BADGE_COLOR="$(urlencode $3)"
  MARKDOWN_TEXT="${MARKDOWN_TEXT}&color=${BADGE_COLOR}"
  # Include the badge logo (if applicable) in the markdown text
  if [ -n "$4" ]; then
    BADGE_LOGO="$(urlencode $4)"
    MARKDOWN_TEXT="${MARKDOWN_TEXT}&logo=${BADGE_LOGO}"
  fi
  # Include the file extension and the style of the badge
  MARKDOWN_TEXT="${MARKDOWN_TEXT}&style=flat-square"
  # Create the markdown image having the built URL.
  MARKDOWN_TEXT="![${BADGE_LABEL}](${MARKDOWN_TEXT})"
  # If an URL was provided, enclose the badge in a markdown link
  if [ -n "$5" ]; then
    BADGE_LINK="$(urlencode $5)"
    MARKDOWN_TEXT="[${MARKDOWN_TEXT}: ${BADGE_MESSAGE}](${BADGE_LINK})"
  fi
  # Protect all '/' characters so that sed can use '/' as the separator
  MARKDOWN_TEXT=$(echo $MARKDOWN_TEXT|sed 's@/@\\/@g')
  # Insert the markdown text in the readme.
  sed -i "/^${PATTERN_END}/i $MARKDOWN_TEXT" "$README_PATH"
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a text at the end of the last line of the badges list in the readme
# file.
#
# ARGUMENT 1: The text to insert, compatible with a'/' separated sed expression.
#
function insert_at_end_of_latest_badge {
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
echo "Updating the badges in the readme file..."

# ##############################################################################
#
# Remove the existing badges
#
sed -i "/${PATTERN_START}/,/${PATTERN_END}/{//!d}" "$README_PATH"

# ##############################################################################
#
# Parse the package.json file to extract the current version and create the
# corresponding badge.
#
PROJ_VERSION=$(jq -e '.version' ${PACKAGEJSON_PATH} 2> /dev/null)
# The badge is added only if the version key exists in the JSON file.
if [ "$?" -eq 0 ] && [ -n "$PROJ_VERSION" ]; then
  if [[ "$PROJ_VERSION" =~ ^\".*\"$ ]]; then
    PROJ_VERSION="${PROJ_VERSION:1:-1}"
  fi
  # Insert the corresponding badge in the readme file.
  insert_badge "version" "${PROJ_VERSION}" "red"
fi

# ##############################################################################
#
# Parse the package.json file to extract the release date of the version and
# create the corresponding badge.
#
PROJ_DATE=$(jq -e '.release_date' ${PACKAGEJSON_PATH} 2> /dev/null)
# The badge is added only if the release_date key exists in the JSON file.
if [ "$?" -eq 0 ] && [ -n "$PROJ_DATE" ]; then
  if [[ "$PROJ_DATE" =~ ^\".*\"$ ]]; then
    PROJ_DATE="${PROJ_DATE:1:-1}"
  fi
  # Insert the corresponding badge in the readme file.
  insert_badge "release date" "${PROJ_DATE}" "red"
fi

# ##############################################################################
#
# Add line separator.
#
insert_at_end_of_latest_badge '\\n'

# ##############################################################################
#
# Parse the package.json file to extract the operating system identified, and
# create the corresponding badge.
#
OSES=$(jq -e '.os[]' ${PACKAGEJSON_PATH} 2> /dev/null)
# The badge is added only if at least one OS is defined
# (If the "os" key exists and is not an empty array)
if [ "$?" -eq 0 ] && [ -n "$OSES" ]; then
  # Initialize the stringified list of OSes
  OS_LIST=""
  # Change the Internal field separator of the bash for loop so that each item
  # corresponds to a line.
  IFS_ORIGINAL=$IFS
  IFS=$'\n'
  # Loop over the oses
  for raw_os in $OSES; do
    # First strip the leading and tailing '"' characters (if necessary)
    OS="$raw_os"
    if [[ "$OS" =~ ^\".*\"$ ]]; then
      OS="${OS:1:-1}"
    fi
    # Add a separator char in the OS list (if necessary)
    if [ -n "$OS_LIST" ]; then
      OS_LIST="$OS_LIST | "
    fi
    # Add the OS to the list
    OS_LIST="${OS_LIST}${OS}"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
  # Define a logo if only one OS is provided
  LOGO=""
  if [ $(echo -e $OSES | wc -l) -eq 1 ]; then
    OS="${OSES:1:-1}"
    LOGO=$(get_db_val "$OS_ICONDB_PATH" "$OS")
  fi
  # Insert the OS related badge in the readme file.
  insert_badge "platform" "${OS_LIST}" "lightgrey" "$LOGO"
fi

# ##############################################################################
#
# Parse the package.json file to extract the engines name and version, and
# create the corresponding badges.
#
# Get the number of declared engines. Add badges only if the engines key
# in the JSON is declared and not an empty object.
ENGINES_NUM=$(jq -e '.engines[]' "${PACKAGEJSON_PATH}" | wc -l 2> /dev/null)
if [ "$?" -eq 0 ] && [ "$ENGINES_NUM" -gt 0 ]; then
  # Fetch the engines list
  ENGINES_LIST=$(jq '.engines | keys[] as $k | "\($k)£\(.[$k])"' "${PACKAGEJSON_PATH}")
  # Change the Internal field separator of the bash for loop so that each item
  # corresponds to a line.
  IFS_ORIGINAL=$IFS
  IFS=$'\n'
  # Loop over the engines
  for engine_desc in $ENGINES_LIST; do
    # Identify the dependency name and version
    ENGINE_NAME="$(echo ${engine_desc:1:-1} | awk -F '£' '{print $1}')"
    ENGINE_VER="$(echo ${engine_desc:1:-1} | awk -F '£' '{print $2}')"
    # Identify the logo of the engine.
    LOGO=$(get_db_val "$ENGINE_ICONDB_PATH" "$ENGINE_NAME")
    # Insert the corresponding badge in the readme file.
    insert_badge "${ENGINE_NAME}" "${ENGINE_VER}" "brightgreen" "$LOGO"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
fi

# ##############################################################################
#
# Parse the package.json file to extract the dependencies name and version, and
# create the corresponding badges.
#
# Get the number of declared dependencies. Add badges only if the dependencies key
# in the JSON is declared and not an empty object.
DEPS_NUM=$(jq -e '.dependencies[]' "${PACKAGEJSON_PATH}" | wc -l 2> /dev/null)
if [ "$?" -eq 0 ] && [ "$DEPS_NUM" -gt 0 ]; then
  # Fetch the production dependencies list
  DEPS_LIST=$(jq '.dependencies | keys[] as $k | "\($k)£\(.[$k])"' "${PACKAGEJSON_PATH}")
  # Change the Internal field separator of the bash for loop so that each item
  # corresponds to a line.
  IFS_ORIGINAL=$IFS
  IFS=$'\n'
  # Loop over the dependencies
  for dep_desc in $DEPS_LIST; do
    # Identify the dependency name and version
    DEP_NAME="$(echo ${dep_desc:1:-1} | awk -F '£' '{print $1}')"
    DEP_VER="$(echo ${dep_desc:1:-1} | awk -F '£' '{print $2}')"
    # Insert the corresponding badge in the readme file.
    insert_badge "${DEP_NAME}" "${DEP_VER}" "brightgreen" "" "https://www.npmjs.com/package/${DEP_NAME}"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
fi

# ##############################################################################
#
# Parse the package.json file to extract the dev dependencies name and version,
# and create the corresponding badges.
#
# Get the number of declared dependencies. Add badges only if the devDependencies
# key in the JSON is declared and not an empty object.
DEPS_NUM=$(jq -e '.devDependencies[]' "${PACKAGEJSON_PATH}" | wc -l 2> /dev/null)
if [ "$?" -eq 0 ] && [ "$DEPS_NUM" -gt 0 ]; then
  # Fetch the development dependencies list
  DEPS_LIST=$(jq '.devDependencies | keys[] as $k | "\($k)£\(.[$k])"' "${PACKAGEJSON_PATH}")
  # Change the Internal field separator of the bash for loop so that each item
  # corresponds to a line.
  IFS_ORIGINAL=$IFS
  IFS=$'\n'
  # Loop over the dependencies
  for dep_desc in $DEPS_LIST; do
    # Identify the dependency name and version
    DEP_NAME="$(echo ${dep_desc:1:-1} | awk -F '£' '{print $1}')"
    DEP_VER="$(echo ${dep_desc:1:-1} | awk -F '£' '{print $2}')"
    # Insert the corresponding badge in the readme file.
    insert_badge "${DEP_NAME}" "${DEP_VER}" "brightgreen" "" "https://www.npmjs.com/package/${DEP_NAME}"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
fi

# ##############################################################################
#
# Parse the package.json file to extract the license name and create the
# corresponding badge.
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
    # Insert the badge for the license
    insert_badge "license" "${LICENSE_NAME}" "blue" "" "${LICENSE_URL}"
  else
    echo -e "\tWARNING: Not generating badge for license since it is a complex SPDX license expression syntax version 2.0"
  fi
fi

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo -e "\tFINISHED"
