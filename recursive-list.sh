#!/bin/bash

TOC_FILE="toc.md"

function add-file {

	FILE=$1
	TITLE=`head -n 1 $FILE | sed -E "s/[#]{1,}[ ]{0,}//"`

	echo "" >> toc.tmp
	echo "[${TITLE}](${FILE})" >> toc.tmp
}

function add-dir {

	for f in $(find $1 -maxdepth 1 -name '*.md')
	do
		add-file $f
	done
	
	for dir in $(find $1 -type d -not -path '*/\.*')
	do
		if [ -f "${dir}/${TOC_FILE}" ]
		then
			add-file ${dir}/${TOC_FILE}

		elif [ ! "$dir" = "${1}" ]
		then
			echo "" >> toc.tmp
			echo "## $dir" >> toc.tmp
			add-dir $dir
		fi
	done
}

# Script setup
if [ -d "$1" ]
then
	cd $1
else
	echo "Error: Invalid input directory!"
	echo "Usage: generate [ DIRECTORY ]"
	exit
fi

# Removes old TOC so it isn't included
if [ -f "${TOC_FILE}" ]
then
	rm ${TOC_FILE}
fi

# Setup TOC File
echo "# Table of Contents" > toc.tmp

add-dir .

mv toc.tmp ${TOC_FILE}
