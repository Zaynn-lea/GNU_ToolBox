
# Utility script to help build makefiles
#
#
# There is optinoal arguments :
#
#	- the name of the future makefiles, by default it is "Makefile"
# 	  If the name is already taken
# 	  It'll add "_new" or "_new{i}" to the name
#
#
# It will :
#	- create a file
#	- fill it with a template
#	- open nano
#
#---------------------------------------------------------
#
# made by :
#	Gely Léandre :: https://github.com/Zaynn-lea
#
# date :
#	started      :	23 / 10 / 2024
#	last updated :	 6 / 11 / 2024


#!/bin/bash


if [[ $# -le 1 ]]
then

	# Dealing with the possibility of the name being already taken

	if [[ $# -eq 0 ]]
	then
		name="Makefile"

	elif [[ -e $1 ]]
	then
		name=${1}_new

		i=0
		while [[ -e ${name} ]]
		do
			name=${name%$((i-1))}${i}
			i=$((i+1))
		done
	else
		$name=$1
	fi


	# +------------------+
	# |   Main script :  |
	# +------------------+

	touch $name

	exec 3>& $name

	echo "" >> $name
	echo "GCCFlags = -Wall -g" >> $name
	echo "" >> $name
	echo "" >> $name
	echo -e "all:\t" >> $name
	echo "" >> $name
	echo "" >> $name
	echo "clean:" >> $name
	echo -e "\trm *.o" >> $name
	echo "" >> $name

	exec 3>&-

	nano $name

else
	# if no file name is given or additionnal parameters
	echo "You can't pass more than one arguments" >&2
	exit 1
fi

