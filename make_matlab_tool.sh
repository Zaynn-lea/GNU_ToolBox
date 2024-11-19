
# Utility script to help build matlab scripts
#
#
# It requires 1 parapmeter :
#
#	- the name of the future MatLab file
#	  If the name is already taken
# 	  It'll add "_new" or "_new{i}" to the name
#
#
# There are optional arguments :
#
#	- -f : make a function file instead of a script file
#	- -d : add a documentation template at the start of the file
#
#
# It will :
#	- create a file
#	- fill it with a template
#	- open nano
#
#-----------------------------------------------------------------------------------------------------
#
# made by :
#	Gély Léandre :: https://github.com/Zaynn-lea
#
# date :
#	started      :   4 / 11 / 224
#	last updated :	19 / 11 / 2024


#!/bin/bash


if [[ $# -gt 0 ]]
then
	# Options variables

	has_doc=0
	is_func=0

	ext='.m'


	# Parser to take care of the parameters
	# takes care of multi-char options, single-char options and standards parameters, in this order

	for arg in "$@"
	do
		if [[ ${arg:0:1} = '-' ]]
		then
			for (( i=1 ; i<${#arg} ; i++ ))
			do
				case ${arg:$i:1} in
					(d) has_doc=1 ;;
					(f) is_func=1 ;;
				esac
			done
		else
			name=$arg
		fi
	done

	# dealing with the possibility of a file having the same name

	if [[ -e ${name}${ext} ]]
	then
		name=${name}_new

		i=0
		while [[ -e ${name}${ext} ]]
		do
			name=${name%$((i-1))}${i}
			i=$((i+1))
		done
	fi

	name=${name}${ext}


	# +---------------+
	# |  Main Script  |
	# +---------------+

	touch $name

	exec 3>& $name

	if [[ $has_doc -eq 1 ]]
	then
		# Documentation template

		today=$(date +%d' / '%m' / '%y)

		echo "" >> $name
		echo "%%" >> $name
		echo "" >> $name
		echo "" >> $name
		echo "----------------------------------------------------------------------------" >> $name
		echo "" >> $name
		echo "Made by :" >> $name
		echo -e "\t- "$USER >> $name
		echo "" >> $name
		echo "Date :" >> $name
		echo -e "\tstarted      :  "$today >> $name
		echo -e "\tlast updated :  "$today >> $name
		echo "%%" >> $name
		echo "" >> $name
	fi

	if [[ $is_func -eq 1 ]]
	then
		# Function template

		echo "" >> $name
		echo "function [] = ${name%%.*}()" >> $name
		echo -e "\t" >> $name
		echo "end" >> $name
		echo "" >> $name
	else
		# Script template

		echo "" >> $name
		echo "% Cleaning the environement" >> $name
		echo "" >> $name
		echo "clf" >> $name
		echo "clear" >> $name
		echo "clc" >> $name
		echo "" >> $name
		echo "hold on" >> $name
		echo "" >> $name
		echo "" >> $name
		echo "% +------------------+" >> $name
		echo "% |   Main Script :  |" >> $name
		echo "% +------------------+" >> $name
		echo "" >> $name
	fi

	exec 3>&-

	nano $name

	exit 0

else
	# if no file name is given or if too many arguments ar given :
	echo "You have to give at least one arguments, the name of the file" >&2
	exit 1
fi
