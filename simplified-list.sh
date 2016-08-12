#!/bin/bash

function add-file {

	FILE=$1
	TITLE=`head -n 1 $FILE | sed -E "s/[#]{1,}[ ]{0,}//"`

	echo "" >> toc.tmp
	echo "[${TITLE}](${FILE})" >> toc.tmp

}

# Checks if cmdln arg is a dir
if [ -d "$1" ]; then
	cd $1
else
	echo "Error: Not a valid File or Directory!"
	echo "Usage: generate [ DIRECTORY ]"
	exit
fi

# Removes old TOC file
if [ -f "toc.md" ]; then
	rm toc.md
fi

# File List & UI Setup
list=`find . -maxdepth 1 -name '*.md'`
total=`echo $list | wc -w`
count=0


# Create new TOC file
echo "# Table of Contents" > toc.tmp

for f in $list
do
	add-file $f
	((count++))
	echo -ne "Processing... $(((count * 100) / total))%\r"
done

mv toc.tmp toc.md
