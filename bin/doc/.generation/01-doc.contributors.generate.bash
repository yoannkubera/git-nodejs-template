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
# Generates the contributors displayed in the AUTHORS.md file from the
# package.json file.
#
# ==============================================================================

# -- GLOBAL --------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# The directory of this script, the directory of the project and the path of the
# contributors file.
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_ROOT=$(realpath -m --relative-to=. ${SCRIPT_DIR}/../../..)
AUTHORS_PATH="${PROJ_ROOT}/AUTHORS.md"
PACKAGEJSON_PATH="${PROJ_ROOT}/package.json"

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Reads a specific field in the json file containing the description of one or
# more persons, and displays the number of persons it describes.
#
# ARGUMENT 1:     The name of the field where the persons are described in the
#                 'package.json' file.
#
# RETURN (ECHO):  The number of person entries inside the field.
#
# ERROR:          The 'package.json' file does not declare such a field.
#
function read_persons_number_in_json {
  jq -e ".$1 | if type==\"array\" then length else if type==\"string\" then 1 else 0 end end" "${PACKAGEJSON_PATH}" 2> /dev/null
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Reads a specific field in the json file containing the description of one or
# more persons, builds a Markdown list containing them and inserts that list
# inside .
#
# Persons are described in the JSON as either a single value or an array of
# persons. A person is:
#   - Either a string having the format "NAME <EMAIL> (URL)" where the EMAIL and
#     URL parts are optionnal;
#   - Or an object having the "name" key and optionnaly the "email" and "url" keys.
#
# ARGUMENT 1:   The name of the field where the persons are described in the
#               'package.json' file.
#
function read_persons_in_json {
  # Convert the JSON so that an isolated item will be shown as an array
  # with size 1
  CONTRIBUTORS_JSON=$(jq ".$1 | . as \$l | if type!=\"array\" then [ \$l ] else \$l end" "${PACKAGEJSON_PATH}")
  # Then read the items of the resulting array and convert object
  # representations of the items to a string one.
  CONTRIBUTORS_JSON=$(echo -e $CONTRIBUTORS_JSON | jq -r '.[] | . as $l | if type=="object" then "\($l.name) <\($l.email)> (\($l.url))" else "\($l)" end')
  # Change the Internal field separator of the bash for loop so that each item
  # corresponds to a line.
  IFS_ORIGINAL=$IFS
  IFS=$'\n'
  # Iterate over the entries of the list, to print the persons.
  for person_desc in $CONTRIBUTORS_JSON; do
    # Read the name of the contributor.
    PERSON_NAME="$(echo $person_desc | sed -n -e 's/\([^<(]*\).*/\1/p' | sed -e 's/[[:space:]]*$//')"
    # Read the email of the contributor.
    PERSON_EMAIL="$(echo $person_desc | sed -n -e 's/.*\(<.*>\).*/\1/p' | sed -e 's/[[:space:]]*$//')"
    if [ "$PERSON_EMAIL" != "<null>" ]; then
      PERSON_EMAIL="${PERSON_EMAIL:1:-1}"
    else
      PERSON_EMAIL=""
    fi
    # Read the url of the contributor.
    PERSON_URL="$(echo $person_desc | sed -n -e 's/[^(]*\((.*)\).*/\1/p' | sed -e 's/[[:space:]]*$//')"
    if [ "$PERSON_EMAIL" != "(null)" ]; then
      PERSON_URL="${PERSON_URL:1:-1}"
    else
      PERSON_URL=""
    fi
    # Insert the person at the end of the file.
    PERSON_MARKDOWN="* __${PERSON_NAME}__"
    if [ -n "$PERSON_EMAIL" ]; then
      PERSON_MARKDOWN="${PERSON_MARKDOWN} - <$PERSON_EMAIL>"
    fi
    if [ -n "$PERSON_URL" ]; then
      PERSON_MARKDOWN="${PERSON_MARKDOWN} ($PERSON_URL)"
    fi
    insert_line_at_end "$PERSON_MARKDOWN"
  done
  # Restore the Internal field separator
  IFS=$IFS_ORIGINAL
}

# -- FUNCTION ------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# Inserts a line of text at the end of the authors file.
#
# ARGUMENT 1:   The text to add.
#
function insert_line_at_end {
  echo -e "$1" >> $AUTHORS_PATH
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
echo "Updating the people in the authors file..."

# ##############################################################################
#
# Remove the existing contributors
#
> $AUTHORS_PATH

# ##############################################################################
#
# Print the header of the file.
#
insert_line_at_end "# Team"
insert_line_at_end
insert_line_at_end "> This software has been created owing to the efforts of the following people"
insert_line_at_end
insert_line_at_end "__Note:__ The contents of this file are automatically generated from the contents"
insert_line_at_end "of the \`package.json\` file, and especially its fields \`author\`, \`maintainers\` and"
insert_line_at_end "\`contributors\` (see the [NPM documentation about such fields](https://docs.npmjs.com/files/package.json#people-fields-author-contributors))."

# ##############################################################################
#
# Parse the package.json file to extract the author and create the
# corresponding entries in the markdown file.
#
# Get the number of declared authors. Add a markdown item only if the
# authors key in the JSON is declared and not empty.
CONTRIBUTORS_NUM=$(read_persons_number_in_json "author")
if [ "$?" -eq 0 ] && [ "$CONTRIBUTORS_NUM" -gt 0 ]; then
  # Print the header of the contributors list
  insert_line_at_end
  insert_line_at_end "## Main author"
  insert_line_at_end
  insert_line_at_end "> The main author of the project."
  insert_line_at_end
  # Reads the contributors list and adds the persons in it.
  read_persons_in_json "author"
fi

# ##############################################################################
#
# Parse the package.json file to extract the maintainers and create the
# corresponding entries in the markdown file.
#
# Get the number of declared maintainers. Add a markdown item only if the
# maintainers key in the JSON is declared and not empty.
CONTRIBUTORS_NUM=$(read_persons_number_in_json "maintainers")
if [ "$?" -eq 0 ] && [ "$CONTRIBUTORS_NUM" -gt 0 ]; then
  # Print the header of the contributors list
  insert_line_at_end
  insert_line_at_end "## Maintainers"
  insert_line_at_end
  insert_line_at_end "> People maintaining this software (including the releases between git branches)"
  insert_line_at_end
  # Reads the contributors list and adds the persons in it.
  read_persons_in_json "maintainers"
fi

# ##############################################################################
#
# Parse the package.json file to extract the contributors and create the
# corresponding entries in the markdown file.
#
# Get the number of declared contributors. Add a markdown item only if the
# contributors key in the JSON is declared and not empty.
CONTRIBUTORS_NUM=$(read_persons_number_in_json "contributors")
if [ "$?" -eq 0 ] && [ "$CONTRIBUTORS_NUM" -gt 0 ]; then
  # Print the header of the contributors list
  insert_line_at_end
  insert_line_at_end "## Contributors"
  insert_line_at_end
  insert_line_at_end "> Contributors to either the planning, development, test and bug fixing of the project."
  insert_line_at_end
  # Reads the contributors list and adds the persons in it.
  read_persons_in_json "contributors"
fi

# ##############################################################################
#
# Print a message telling that it was a success.
#
echo -e "\tFINISHED"
