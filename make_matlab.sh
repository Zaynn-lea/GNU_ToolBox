
# Utility script to help build matlab scripts
#
# It requires 1 parapmeter :
#	- the name of the future MatLab file
#
# If the name is already taken
# It'll add "_new" or "_new{i}" to the name
#
# It will :
#	- create a file
#	- fill it with a template
#	- open nano
#
#-------------------------------------------------------------------------
#
# made by :
#	Gély Léandre :: https://github.com/Zaynn-lea
#
# date :
#	from :   4 / 11 / 2024
#	to   :	 5 / 11 / 2024


#!/bin/bash


if [[ $# -gt 0 ]]
then

	is_func=0

	name=$1
	ext='.m'

	# taking care of the options (-something)

	while getopts d:f o
	do
		case $o in
			(d) ;;		# TODO : Documentation
			(f) is_func=1;;

			(*) usage
		esac
	done

	# dealing with the possibility of a file having the same name

	if [[ -e $1.m ]]
	then
		name=${1}_new.m
	else
		name=${1}.m
	fi


	# +---------------+
	# |  Main Script  |
	# +---------------+

	touch $name

	exec 3>& $name

	if [[ $is_func -eq 1 ]]
	then
		echo "" >> $name
		echo "function [] = ${name##.*}()" >> $name
		echo "" >> $name
		echo "end" >> $name
		echo "" >> $name
	else
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
