#!/bin/sh

# Ideally, this could all be done through liquid formatting, but I don't understand that well enough tbh

# Note: this assumes that the doc files DO NOT have YML headers yet (at least, the SUMMARY file)

echo "# Project Listing" > list.md
echo "" >> list.md

for dir in `find . -type d`
do
	if [ -f "${dir}/summary.md" ]
	then
		cat ${dir}/summary.md >> list.md
		echo "" >> list.md
		echo "[Read More](${dir}/toc.md)" >> list.md
		echo "" >> list.md
	fi
done
