#!/bin/bash

. _pick_pythons.sh

XMLLINT=`which xmllint`

#Halt on error
set -e
#Display all executed commands
set -x

#Ensure the non-XML output doesn't fail, first.
"$PYTHON3" idifference.py --summary ../samples/difference_test_[01].xml > idifference_test.txt

#Generate XML output.
"$PYTHON3" idifference.py --xml idifference_test.dfxml ../samples/difference_test_[01].xml
if [ ! -x "$XMLLINT" ]; then
  echo "Error: xmllint not found.  Can't check for if generated DFXML is valid XML.  Install libxml2 (possibly xmlutils) to complete these unit tests." >&2
  exit 1
fi

xmllint --format idifference_test.dfxml >idifference_test_formatted.dfxml

_check_counts() {
  #Check expected number of fileobjects appears
  test 4 == $(grep '<fileobject' $1 | wc -l)
  test 1 == $(grep 'delta:new_file' $1 | wc -l)
  test 1 == $(grep 'delta:deleted_file' $1 | wc -l)
  test 2 == $(grep 'delta:changed_file' $1 | wc -l)
  test 7 == $(grep 'delta:changed_property' $1 | wc -l)
}

_check_counts idifference_test_formatted.dfxml

#Check that the differential DFXML is cat'able

"$PYTHON3" cat_fileobjects.py --debug idifference_test.dfxml > idifference_test_cat.dfxml
xmllint --format idifference_test_cat.dfxml >idifference_test_cat_formatted.dfxml
_check_counts idifference_test_cat_formatted.dfxml
