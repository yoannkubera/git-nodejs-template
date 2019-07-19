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
# Development depenencies are generated between the following HTML comments:
#     <!-- START dev-deps -->
#     <!-- END dev-deps -->
#
# Production depenencies are generated between the following HTML comments:
#     <!-- START prod-deps -->
#     <!-- END prod-deps -->
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script, the directory of the project and the path of the
# dependencies file.
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_ROOT=$(realpath -m --relative-to=. ${SCRIPT_DIR}/../../..)
DEPENDENCIES_PATH="${PROJ_ROOT}/DEPENDENCIES.md"
PACKAGEJSON_PATH="${PROJ_ROOT}/package.json"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The patterns used to identify where to put the development related dependencies
# in the DEPENDENCIES.md file
#
PATTERN_DEV_START="<!-- START dev-deps -->"
PATTERN_DEV_END="<!-- END dev-deps -->"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The patterns used to identify where to put the production related dependencies
# in the DEPENDENCIES.md file
#
PATTERN_PROD_START="<!-- START prod-deps -->"
PATTERN_PROD_END="<!-- END prod-deps -->"

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# ASCII expression equivalent to a space char, used in the 'insert_at_end_of_latest_AAAA_dep'
# functions to print an empty line.
#
AN_EMPTY_LINE='\\x20'

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a text at the end of the last line of the development dependencies list
# in the dependencies file.
#
# ARGUMENT 1: The text to insert, compatible with a'/' separated sed expression.
#
function insert_at_end_of_latest_dev_dep {
  # Insert the markdown text in the readme.
  sed -i "/^${PATTERN_DEV_END}/i $1" "$DEPENDENCIES_PATH"
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a new dependency at the end of the nodejs development dependencies in
# the Dependencies file.
#
# ARGUMENT 1:   The name of the nodejs package
# ARGUMENT 2:   The version of the nodejs package
#
function insert_dev_dep {
  # Create the opening part of the markdown text of the dependency
  MARKDOWN_TEXT="* [$1](https://www.npmjs.com/package/$1) (version \`$2\`)"
  # Protect all '/' characters so that sed can use '/' as the separator
  MARKDOWN_TEXT=$(echo $MARKDOWN_TEXT|sed 's@/@\\/@g')
  # Insert the dependency text in the markdown file.
  insert_at_end_of_latest_dev_dep "$MARKDOWN_TEXT"
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a text at the end of the last line of the production dependencies list
# in the dependencies file.
#
# ARGUMENT 1: The text to insert, compatible with a'/' separated sed expression.
#
function insert_at_end_of_latest_prod_dep {
  # Insert the markdown text in the readme.
  sed -i "/^${PATTERN_PROD_END}/i $1" "$DEPENDENCIES_PATH"
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a new dependency at the end of the nodejs production dependencies in
# the Dependencies file.
#
# ARGUMENT 1:   The name of the nodejs package
# ARGUMENT 2:   The version of the nodejs package
#
function insert_prod_dep {
  # Create the opening part of the markdown text of the dependency
  MARKDOWN_TEXT="* [$1](https://www.npmjs.com/package/$1) (version \`$2\`)"
  # Protect all '/' characters so that sed can use '/' as the separator
  MARKDOWN_TEXT=$(echo $MARKDOWN_TEXT|sed 's@/@\\/@g')
  # Insert the dependency text in the markdown file.
  insert_at_end_of_latest_prod_dep "$MARKDOWN_TEXT"
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
echo "Updating the dependencies list in the DEPENDENCIES file..."

# ##############################################################################
#
# Remove the existing development dependencies
#
sed -i "/${PATTERN_DEV_START}/,/${PATTERN_DEV_END}/{//!d}" "$DEPENDENCIES_PATH"

# ##############################################################################
#
# Parse the JSON file to find the development dependencies and add them to the
# markdown documentation.
#
# Print a new line at the beginning of the dependencies
insert_at_end_of_latest_dev_dep $AN_EMPTY_LINE
# Get the number of declared dependencies. Add items only if the devDependencies
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
    insert_dev_dep "${DEP_NAME}" "${DEP_VER}"
    # Print a new line after the dependency
    insert_at_end_of_latest_dev_dep "$AN_EMPTY_LINE"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
else
  # If no development dependencies are defined, print a simple message.
  insert_at_end_of_latest_dev_dep "The project has no such dependencies"
  # Print a new line at the end of the dependencies
  insert_at_end_of_latest_dev_dep "$AN_EMPTY_LINE"
fi

# ##############################################################################
#
# Remove the existing production dependencies
#
sed -i "/${PATTERN_PROD_START}/,/${PATTERN_PROD_END}/{//!d}" "$DEPENDENCIES_PATH"

# ##############################################################################
#
# Parse the JSON file to find the production dependencies and add them to the
# markdown documentation.
#
# Print a new line at the beginning of the dependencies
insert_at_end_of_latest_prod_dep "$AN_EMPTY_LINE"
# Get the number of declared dependencies. Add items only if the dependencies key
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
    insert_prod_dep "${DEP_NAME}" "${DEP_VER}"
    # Print a new line after the dependency
    insert_at_end_of_latest_prod_dep "$AN_EMPTY_LINE"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
else
  # If no production dependencies are defined, print a simple message.
  insert_at_end_of_latest_prod_dep "The project has no such dependencies"
  # Print a new line at the end of the dependencies
  insert_at_end_of_latest_prod_dep "$AN_EMPTY_LINE"
fi

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo -e "\tFINISHED"
