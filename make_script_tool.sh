
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
#
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
#	startded       :  10 / 10 / 2024 ?
#	last updated   :   6 / 11 / 2024


#!/bin/bash


if [[ $# -ge 1 ]]
then

	has_doc=0

	ext='.sh'


	# Catching the file name amoung the options

	for arg in $@
	do
		if [[ ${arg:0:1} = '-' ]]
		else
			for (( i=1 ; i<${arg#} ; i++ ))
			do
				(d) has_doc=1 ;;
			done
		then
			name=$arg
		fi
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

	touch $name
	chmod a+x $name

	exec 3>& $name

	if [[ has_doc -eq 1 ]]
	then
		# Documentation template

		today=$(date +%d' / '%m' / '%y)

		echo "" >> $name
		echo "# " >> $name
		echo "#" >> $name
		echo "#--------------------------------------------------------------------------------" >> $name
		echo "#" >> $name
		echo "# Made by :" >> $name
		echo -e "#\t- "$USER >> $name
		echo "#" >> $name
		echo "# Date :" >> $name
		echo -e "#\tstarted      :  "$today >> $name
		echo -e "#\tlast updated :  "$today >> $name
		echo "" >> $name
	fi

	echo "" >> $name
	echo "#!/bin/bash" >> $name
	echo "" >> $name

	exec 3>&-

	nano $name

else
	# if no file name is given or additionnal parameters
	echo "You have to give at least on parameter, the name of the file" >&2
	exit 1
fi

