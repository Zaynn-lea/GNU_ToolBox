
#	 /+====================+\
#	 ||   Pretty clear !   ||
#	 \+====================+/
#
# Clear the screen and add a header at the top
# Header that you can customise with options
#
#
# By default, it does :
#	- Clean the console
#	- put a ls -l as header at the top
#
#--------------------------------------------------------------------------------
#
# Made by :
#	- Gély léandre :: https://github.com/Zaynn-lea
#
# Date :
#	started      :  06 / 11 / 24
#	last updated :  06 / 11 / 24


#!/bin/bash


is_all=0
is_light=0

has_git=0
has_make=0

# Taking care of the options (-something)

# I had to do the parcer myself since I wasn't able to do it using getopts
for arg in $@
do
	if [[ ${arg:0:1} = '-' ]]
	then
		for (( i=1 ; i<${#arg} ; i++ ))
		do
			case ${arg:$i:1} in
				(a) is_all=1;;
				(l) is_light=1;;
				(g) has_git=1;;
				(m) has_make=1;;
			esac
		done
	fi
done


# +------------------+
# |   Main script :  |
# +------------------+

ls_options='-l'

clear

if [[ $is_light -eq 1 ]]
then
	ls_options=''
fi

if [[ $is_all -eq 1 ]]
then
	tty
	ls_options='-ailF'
fi

ls ${ls_options}

if [[ $has_git -eq 1 ]]
then
	echo ''
	git status
fi

if [[ $has_make -eq 1 ]]
then
	echo ''
	make
fi


exit 0
