
# Utility script to help build other scripts
#
# It requires 1 parameters :
#	- the name of the future script
#
# If the name is already taken
# it'll add "_new" or "_new{i}" to the name
#
# It will :
#	- create a file
#	- give it execution write
#	- open nano
#
#---------------------------------------------------------
#
# made by :
#	Gely Léandre :: https://github.com/Zaynn-lea
#
# date :
#	from :	10 / 10 / 2024 ?
#	to   :	 5 / 11 / 2024


#!/bin/bash


if [[ $# -eq 1 ]]
then

	name=$1
	ext='.sh'

	# Dealing with the possibility of a file having the same name

	if [[ -e ${name}${ext} ]]
	then
		name=${name}_new

		i=0
		while [[ -e ${name}${ext} ]]
		do
			name=${name%$((i-1))}${i}
			i=$((i + 1))
		done
	fi

	name=${name}${ext}


	# +------------------+
	# |   Main script :  |
	# +------------------+

	touch $name
	chmod a+x $name

	exec 3>& $name

	echo "" >> $name
	echo "#!/bin/bash" >> $name
	echo "" >> $name

	exec 3>&-

	nano $name

else
	# if no file name is given or additionnal parameters
	echo "You have to give one and only one parametter : the name of the file" >&2
	exit 1
fi

