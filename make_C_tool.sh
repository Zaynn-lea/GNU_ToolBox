
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
#	- -d : add a documentation template at the start of the file
#	- -m : add a module with at least one function (void by default)
#		and the coresponding header file
#
#	- --cpp : switch from C to C++
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
#	last updated :	19 / 11 / 2024


#!/bin/bash


if [[ $# -gt 0 ]]
then
	# Options variables

	has_doc=0
	is_module=0

	is_cpp=0


	ext='.c'
	ext_2='.h'


	# Parser to take care of the parameters
	# takes care of multi-char options, single-char options and standards parameters, in this order

	for arg in "$@"
	do
		if [[ ${arg:0:2} = '--' ]]
		then
			# Multi-character options :

			# Check and search for an = (option of the form --something=some_other_thing
			i=2
			while test ${arg:$i:1} != '=' -a $i -lt ${#arg}
			do
				i=$(( $i+1 ))
			done

			case ${arg:2:$(( $i-2 ))} in
				(cpp)  is_cpp=1 ;;
			esac

		elif [[ ${arg:0:1} = '-' ]]
		then
			# Single-character options :

			for (( i=1 ; i<${#arg} ; i++ ))
			do
				case ${arg:$i:1} in
					(d) has_doc=1   ;;
					(m) is_module=1 ;;
				esac
			done
		else
			# normal arguments and parameters :

			name=$arg
		fi
	done


	# Taking care of the name :

	if [[ $is_cpp -eq 1 ]]
	then
		ext='.cpp'
	fi

	# We can't have an empty filename
	if [[ ${#name} -eq 0 ]]
	then
		echo "You must give a name to your file/project." >&2
		exit 1
	fi

	# Dealing with the possibility of a file having the same name
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

	# If the header name exist, we can't create it :

	if [[ -e ${name%%.*} ]]
	then
		echo "The headerfile name is already taken, therefore it can't be created." >&2
		exit 1
	fi

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
		# Module template

		echo "" >> $name
		echo "void ${f_name}()" >> $name
		echo "{" >> $name
		echo -e "\t" >> $name
		echo "}" >> $name
		echo "" >> $name


		# Taking care of the header

		f_name=${name%%.*}
		m_name=${f_name}${ext_2}

		touch $m_name

		exec 4>& $m_name

		# Header template

		echo "" >>$m_name
		echo "void ${f_name}() ;" >>$m_name
		echo "" >>$m_name


		exec 3>&-

	else
		# Program template

		echo "" >> $name
		if [[ is_cpp -eq 1 ]]
		then
			echo "#include <iostream>" >> $name
		else
			echo "#include <stdio>" >> $name
		fi
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
