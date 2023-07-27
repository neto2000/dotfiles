#!/bin/bash

OUTPUT=$(~/documents/bash-scripts/title.sh)

ERROR=""

VAR=""


if [[ $OUTPUT = $ERROR ]] 
then
	VAR="DESKTOP"
else
	VAR="$OUTPUT"
fi

echo $VAR
