#!/bin/bash

# Input Directory
INPUT=$1

# How many dirs to recurse into
DEPTH=1

function add-file {

	FILE=$1
	TITLE=`head -n 1 $FILE | sed -E "s/[#]{1,}[ ]{0,}//"`

	echo "" >> toc.tmp
	echo "[${TITLE}](${FILE})" >> toc.tmp

}

if [ -f "toc.md" ]; then
	rm toc.md
fi

echo "# Table of Contents" > toc.tmp

if [ -d "$INPUT" ]; then
	
	for f in $(find $INPUT -maxdepth $DEPTH -name '*.md')
	do
		add-file $f
	done
else
	echo "Error: Not a valid File or Directory!"
	echo "Usage: generate [ FILE | DIRECTORY ]"
fi

mv toc.tmp toc.md
