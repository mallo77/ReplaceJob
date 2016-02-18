#!/bin/bash
#===================================================================================================
#AUTHOR			: Mathius Girik Allo
#TITLE       	: replaceTokens.sh
#DATE		 	: 04/02/2016
#
#DESCRIPTION 	: This script will take an html file, with placeholders 
#			   		that are marked with double square brackets, and replace 
#			   		the value of the placeholders with the corresponding value 
#			   		that is found in a properties file
#
#DEPENDENCIES	: It requires 'dirname' and 'basename' bash command to be available
#
#USAGE		 	: ./replaceTokens.sh <path/to/input/file> <path/to/conf/file> <path/to/output/file>
#			   	  ./replaceTokens.sh ../input/index.html ../conf/test.properties ../ouput/index.html
#===================================================================================================

# INPUT_FILE      - an input html file that contains the placeholders to be replaced 
# OUTPUT_FILE     - an output html file after replacing all the placeholders
# CONFIG_FILE 	  - a properties file that contains key/value pairs to used for the replacement
INPUT_FILE="$1"
CONFIG_FILE="$2"
OUTPUT_FILE="$3"


# define usage function
usage () {
	echo "Usage: $0 <input file> <properties file> <output file>"
	exit 1
}


# invoke usage if incorrect PARAMETERS are supplied
if [[ $# -lt 3 ]]; then
	echo "Error: invalid number of parameters"
	usage
fi


# isFileExist function definition
isFileExist () {
	# to check if the specified file already exist or not in the file system 
	# 0 is return for "success"

	local f="$1"

	if [ -f "$f" ]; then
		return 0
	else
		return 1
	fi
}


# validate function definition
validate () {
	# check existence of INPUT_FILE parameter
	# check existence of CONFIG_FILE parameter		

	if ( ! isFileExist "$INPUT_FILE" ) then
	 	echo "Error: '$INPUT_FILE' file not found"
	 	usage
	fi

	if ( ! isFileExist "$CONFIG_FILE" ) then
	 	echo "Error: '$CONFIG_FILE' file not found"
	 	usage
	fi
}


# initialize function definition
initialize () {
	# Initialize to ensure OUTPUT_FILE is available
	# copy content of INPUT_FILE to OUTPUT_FILE by replacing its content 
	# if the current OUTPUT_FILE already exists

	if [ ! -e "$OUTPUT_FILE" ]; then
		DIR=$(dirname "${OUTPUT_FILE}")
		FILE=$(basename "${OUTPUT_FILE}")

		mkdir -p $DIR
		touch $OUTPUT_FILE	
	fi

	cat $INPUT_FILE > $OUTPUT_FILE
}


# main function definition 
main () {
	# reading content of properties file line by line
	# use '-r' option to prevent backslash escapes from being interpreted
	# use '|| [[ -n $line ]]' to prevent last line from being ignored if properties file doesn't 
	# end with a newline ('\n')
	
	while read -r line || [[ -n "$line" ]]; do
		
		# convert the key/value pair entry to an array using '=' separator  
		IFS='=' read -a ENTRY <<< "$line"

		# Key will be the 1st element in the array and Value will be 2nd element in the array
		# use echo command to trim spaces for both Key and Value
		KEY=$(echo ${ENTRY[0]})
		VAL=$(echo ${ENTRY[1]})

		# using sed command to perform global replace
		# NOTE: On MacOS an empty space ('') is needed after -i option to tell sed 
		# to use a zero-length extension for the backup
		sed -i '' "s/\[\[$KEY\]\]/$VAL/g" $OUTPUT_FILE 
				 				 
	done < "$CONFIG_FILE"
}

# execute replaceTokens.sh 
validate
initialize
main