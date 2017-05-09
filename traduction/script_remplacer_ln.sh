#!/bin/bash

list_file=$(find -type f)

for file in $list_file
do
	echo $file
	cat $file |grep "tooltip"
	#sed  -n "s/tooltip\(\ \)*: '\(.*\)'/tooltip\1: _l('\2')/g" "$file"
	sed -i "s/tooltip\(\ \)*: \('[^']*\)'/tooltip\1: _l(\2')/g" "$file"
	
done

find -type f -print | xargs grep "tooltip\(\ \)*: \('[^']*\)'" |sed  "s/tooltip\(\ \)*: \('[^']*\)'/tooltip\1: _l(\2')/g"

find -type f -print | xargs grep "tooltip\(\ \)*: \('[^']*\)'" |sed  "s/tooltip\(\ \)*: \('[^']*\)'/tooltip\1: _l(\2')/g"|sed "s/tooltip\(\ \)*: _l([^)]'/toto/g"



find -type f -print | xargs grep "tooltip\(\ \)*: " |sed "s/title\(\ \)*: \('[^']*\)'/title\1: _l(\2')/g"


find -type f -print | xargs grep "tooltip\(\ \)*: \('[^']*\)'" |sed  "s/tooltip\(\ \)*: \('[^']*\)'/tooltip\1: _l(\2')/g"|grep "tooltip\(\ \)*: _l('.*[.:]\(\ \)*')"


 find -type f -print | xargs grep "tooltip\(\ \)*: \('[^']*\)'" |sed  "s/tooltip\(\ \)*: \('[^']*\)'/tooltip\1: _l(\2')/g"|grep "tooltip\(\ \)*: _l('.*[.:]*\(\ \)*')"|sed "s/.*tooltip\(\ \)*: _l(\('[^']*'\).*/\2/g"


sed -i "s/tooltip\(\ \)*: \('[^']*\)'/tooltip\1: _l(\2')/g" "$file"