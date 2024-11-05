
# Utility script to help build makefiles
#
# It requires 1 parameters :
#	- the name of the future makefiles
#
# If the name is already taken
# it'll add "_new" or "_new{i}" to the name
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
#	from :	23 / 10 / 2024
#	to   :	 5 / 11 / 2024


#!/bin/bash


if [[ $# -eq 1 ]]
then

	name=$1

	# Dealing with the possibility of the name being already taken

	if [[ -e $name ]]
	then
		name=${name}_new

		i=0
		while [[ -e ${name} ]]
		do
			name=${name%$((i-1))}${i}
			i=$((i+1))
		done
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
	echo "all:\t" >> $name
	echo "" >> $name
	echo "" >> $name
	echo "clean:" >> $name
	echo "\trm *.o" >> $name
	echo "" >> $name

	exec 3>&-

	nano $name

else
	# if no file name is given or additionnal parameters
	echo "You have to give one and only one parametter : the name of the file" >&2
	exit 1
fi

