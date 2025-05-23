
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
#
# There are optional arguments :
#
#	- -l : a lighter header
#	- -a : a heavier header with more informations, takes priority over -l
#	- -m : execute a make after the pretty clear, when working in C/C++ for example
#	- -g : show you the branches and status of the current git repository
#
#--------------------------------------------------------------------------------
#
# Made by :
#	- Gély léandre :: https://github.com/Zaynn-lea
#
# Date :
#	started      :  06 / 11 / 24
#	last updated :  13 / 05 / 25


#!/bin/bash


# Options variables

is_all=0
is_light=0

has_git=0
has_make=0


# Parser to take care of the parameters
# takes care of multi-char options, single-char options and standards parameters, in this order

# I had to do the parcer myself since I wasn't able to do it using getopts

for arg in "$@"
do
	if [[ ${arg:0:1} = '-' ]]
	then
		for (( i=1 ; i<${#arg} ; i++ ))
		do
			case ${arg:$i:1} in
				(a) is_all=1   ;;
				(l) is_light=1 ;;

				(g) has_git=1  ;;
				(m) has_make=1 ;;
			esac
		done
	fi
done


# +------------------+
# |   Main script :  |
# +------------------+

ls_options='-lh'

if [[ $is_light -eq 1 ]]
then
	ls_options=''
fi

if [[ $is_all -eq 1 ]]
then
	ls_options='-ahilF'
fi


clear


echo ""


max_line_length=$(( $(ls ${ls_options} | sed -e 's/.*/||  &\t/g' | wc -L) - 2 ))


line=''

for (( i=0 ; i<${max_line_length} ; i++ ))
do
	line='-'${line}
done


if [[ $is_all -eq 1 ]]
then
	echo -e $(tty)'\t\t'${USER}
fi


if [[ $is_light -eq 1 && $is_all -ne 1 ]]
then
	ls ${ls_options} --color=always
else
	echo "++"${line}

	ls ${ls_options} --color=always | sed -e 's/.*/||  &/g'

	echo "++"${line}
fi


if [[ $has_git -eq 1 ]]
then
	echo ''
	git branch
	git status
fi

if [[ $has_make -eq 1 ]]
then
	echo ''
	make
fi


echo ""


exit 0

