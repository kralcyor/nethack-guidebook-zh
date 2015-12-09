#! /bin/bash 

# Author: Roy Clark (kralcyor) <kralcyor@kralcyor.info> 
# Date: 2015 
# License: public domain 

set -e 

template="zhTrans-template" 
cmds="zhTrans-cmds.tex" 
table="zhTrans-table.tex" 

write_header() {
	local output="$1" 

	echo "% This file is available under NetHack General Public License. " > "$output" 
	echo "% The License is included in the file \`license'. " >> "$output"
	echo "% This file is generated from $template by ` basename "$0" `" >> "$output" 
	echo "% You may not modify this file directly. " >> "$output" 

	echo -n "% " >> "$output" 
	date >> "$output" 
	echo >> "$output" 
}

write_header "$cmds" 
cat "$template" | grep -v "^#" | sed '/^$/d' \
| awk -F '\t' '{
	if( substr($1, 0, 1) == "%" ) {
		if( substr($1, 0, 8) == "%NEWLINE" ) {
			print "" 
		} else {
			print $0 
		}
	} else {
		print "% " $3 
		print "\\newcommand{\\zhTrans" $1 "}{" $2 "}" 
	}
}' >> "$cmds" 

write_header "$table" 
cat "$template" | grep -v "^#" | grep -v "^%" | sort | sed '/^$/d' \
| awk -F '\t' '{
	print $3 "\t&\t" $2 "\t\\\\" 
}' >> "$table" 

