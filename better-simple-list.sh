#!/bin/bash

conf_force=false
conf_recurse=false

function add-file {

	FILE=$1
	TITLE=`head -n 1 $FILE | sed -E "s/[#]{1,}[ ]{0,}//"`

	echo "" >> toc.tmp
	echo "[${TITLE}](${FILE})" >> toc.tmp
}

function add-dir {

	cd $1

	if [ ! -f "./toc.md" -o "$conf_force" == true ]
	then
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
	fi
}

if [ ! $1 ]
then
	echo "Error: Not a valid File or Directory!"
	echo "Usage: generate (-r) (-f) [ DIRECTORY ]"
	exit
fi

while [ $1 ]
do
	if [ "$1" == "-r" ]
	then
		conf_recurse=true
		shift
	elif [ "$1" == "-f" ]
	then
		conf_force=true
		shift
	elif [ -d "$1" ]
	then
		if [ "$conf_recurse" == true ] 
		then
			# for each dir, add-dir
			for dir in $(find $1 -type d -not -path '*/\.*')
			do
				add-dir $dir
			done
		elif
			# add-dir just $1
			add-dir $1
		fi

		shift
	fi
done
