
# Utility script to help build C and C++ projects
#
#
# It requires 1 parapmeter :
#
#	- the name of the future MatLab file
#	  If the name is already taken
# 	  It'll add "_new" or "_new{i}" to the name
#
#
# There is optional arguments :
#
#	- -m : add a module with at least one function (void by default)
#		and the coresponding header file
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
#	started      :  13 / 11 / 2024
#	last updated :	13 / 11 / 2024


#!/bin/bash


if [[ $# -gt 0 ]]
then

	has_doc=0
	is_module=0

	ext='.c'
	ext_2='.h'


	# Caching the file name amoung all the arguments

	# taking care of the options (-something) and file name
	for arg in $@
	do
		if [[ ${arg:0:1} = '-' ]]
		then
			for (( i=1 ; i<${#arg} ; i++ ))
			do
				case ${arg:$1:1} in
					(d) has_doc=1 ;;
					(a) has_all=1 ;;
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
		echo "/*" >> $name
		echo "" >> $name
		echo "" >> $name
		echo "--------------------------------------------------------------------------------" >> $name
		echo "" >> $name
		echo "Made by :" >> $name
		echo -e "\t- "$USER >> $name
		echo "" >> $name
		echo "Date :" >> $name
		echo -e "\tstarted      :  "$today >> $name
		echo -e "\tlast updated :  "$today >> $name
		echo "*/" >> $name
		echo "" >> $name
	fi

	if [[ $is_module -eq 1 ]]
	then
		f_name=${name%%.*}

		# Module template

		echo "" >> $name
		echo "void ${f_name}()" >> $name
		echo "{" >> $name
		echo -e "\t" >> $name
		echo "}" >> $name
		echo "" >> $name


		# Taking care of the header

		m_name=${f_name}${ext_2}

		touch $m_name

		exec 4>& $m_name

		# Header templates

		echo "" >>$m_name
		echo "void ${f_name}() ;" >>$m_name
		echo "" >>$m_name


		exec 3>&-

	else
		# Program template

		echo "" >> $name
		echo "#include <stdio>" >> $name
		echo "" >> $name
		echo "" >> $name
		echo "int main()" >> $name
		echo "{" >> $name
		echo -e "\t" >> $name
		echo -e "\treturn 0;" >> $name
		echo "}" >> $name
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
