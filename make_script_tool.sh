
# Utility script to help build other scripts
#
#
# It requires 1 parameters :
#
#	- the name of the future script
#	  If the name is already taken
#	  It'll add "_new" or "_new{i}" to the name
#
#
# There is optional arguments :
#	- -d : add a documentation template at the start of the file
#
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

	has_doc=0

	name=$1
	ext='.sh'

	# taking care of the options (-someting)

	while getopts d o
	do
		case $o in
			(d) has_doc=1;;

			(*) usage
		esac
	done

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

	if [[ $has_doc -ed 1 ]]
	then
		# TODO : documentaiton
		echo 'temps'
	fi

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

