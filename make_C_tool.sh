
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
# There are optional arguments :
#
#	- -d : add a documentation template at the start of the file
#	- -m : add a module with at least one function (void by default)
#		and the coresponding header file
#
#	- --cpp : switch from C to C++
#
#	- --func="sig1; sig2; .." : add functions to your C/C++ project based on a signature list
#		where the signatures are of the form : type name(type arg1, type arg2, ..)
#		the signatures are separated by ';'
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
#	last updated :	20 / 11 / 2024


#!/bin/bash


# Functions :

function analyse_save_list() {
	# TODO : function documentation

	# To treat the parameters as one big string, to parse them manually
	raw_list="$*"

	temp=0

	temp_file=".TEMPORAIRE/.temporaire__make_C_tool__header.tmp"


	# We don't want a huge filled file so we empty it each time

	if [[ -e $temp_file ]]
	then
		rm $temp_file
	fi


	touch $temp_file

	exec 10> $temp_file


	# We split the list on each ';' and save each element into a separate line of the temporary file

	for (( i=0 ; i<${#raw_list} ; i++))
	do
		if [[ ${raw_list:$i:1} = ';' ]]
		then
			echo ${raw_list:$temp:$i} >> $temp_file
			temp=$(( $i+1 ))
		fi
	done

	echo ${raw_list:$temp:$i} >> $temp_file

	exec 10>&-
}


if [[ $# -gt 0 ]]
then
	# Options variables

	has_doc=0
	is_module=0

	is_cpp=0
	has_func=0


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
			while [[ ${arg:$i:1} != '=' && $i -lt ${#arg} ]]
			do
				i=$(( $i+1 ))
			done

			case ${arg:2:$(( $i-2 ))} in
				(cpp)  is_cpp=1 ;;
				(func) has_func=1 ; analyse_save_list ${arg:$(( $i+1 ))} ;;
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

	exec 3> $name

	if [[ $has_doc -eq 1 ]]
	then
		# Documentation template

		today=$(date +%d' / '%m' / '%y)

		echo ""   >> $name
		echo "/*" >> $name
		echo ""   >> $name
		echo ""   >> $name
		echo "--------------------------------------------------------------------------------" >> $name
		echo "" 			   >> $name
		echo "Made by :" 		   >> $name
		echo -e "\t- "$USER 		   >> $name
		echo "" 			   >> $name
		echo "Date :" 			   >> $name
		echo -e "\tstarted      :  "$today >> $name
		echo -e "\tlast updated :  "$today >> $name
		echo "*/" 			   >> $name
		echo "" 			   >> $name
	fi

	if [[ $is_module -eq 1 && $has_func -ne 1 ]]
	then
		# Module template

		echo "" 		>> $name
		echo "void ${f_name}()" >> $name
		echo "{" 		>> $name
		echo -e "\t" 		>> $name
		echo "}" 		>> $name
		echo "" 		>> $name


		# Taking care of the header

		f_name=${name%%.*}
		m_name=${f_name}${ext_2}

		touch $m_name

		exec 4> $m_name

		# Header template

		echo "" >> $m_name

		if [[ $is_cpp -eq 1 ]]
		then
			echo "#pragma once"	   >> $m_name
		else
			const_name="__"${f_name^^}"__EXIST__"

			echo "#ifndef "$const_name >> $m_name
			echo "" 		   >> $m_name
			echo "#define "$const_name >> $m_name

		fi

		echo "" 		  >> $m_name
		echo "" 		  >> $m_name
		echo "void ${f_name}() ;" >> $m_name
		echo "" 		  >> $m_name

		if [[ $is_cpp -ne 1 ]]
		then
			echo ""		>> $m_name
			echo "#endif"	>> $m_name
			echo "" 	>> $m_name
		fi

		exec 4>&-
	elif [[ $is_module -eq 1 && $has_func -eq 1 ]]
	then
		# If we asked to have a bunch of functions :

		m_name=${name%%.*}${ext_2}

		touch $m_name

		exec 4> $m_name
		exec 10< .TEMPORAIRE/.temporaire__make_C_tool__header.tmp


		echo "" >> $name

		echo "" >> $m_name
		if [[ $is_cpp -eq 1 ]]
		then
			echo "#pragma once"	   >> $m_name
		else
			const_name="__"${f_name^^}"__EXIST__"

			echo "#ifndef "$const_name >> $m_name
			echo "" 		   >> $m_name
			echo "#define "$const_name >> $m_name

		fi

		while read -u 10 line
		do
			echo $line   >> $name
			echo "{"     >> $name
			echo -e "\t" >> $name

			if [[ ${line%%' '*} != "void" ]]
			then
				echo -e "\treturn ;" >> $name
			fi

			echo "}"     >> $name
			echo ""      >> $name

			# Taking care of the header

			echo $line' ;' >> $m_name
			echo ""        >> $m_name
		done

		if [[ $is_cpp -ne 1 ]]
		then
		echo "#endif"	>> $m_name
		echo "" 	>> $m_name

		fi


		exec 10<&-
		exec 4>&-
	else
		# Program template

		echo "" >> $name

		if [[ is_cpp -eq 1 ]]
		then
			echo "#include <iostream>" >> $name
		else
			echo "#include <stdio>"    >> $name
		fi

		echo "" >> $name


		# If we asked to have a bunch of functions :
		if [[ has_func -eq 1 ]]
		then
			exec 10< .TEMPORAIRE/.temporaire__make_C_tool__header.tmp

			while read -u 10 line
			do
				echo ""      >> $name
				echo $line   >> $name
				echo "{"     >> $name
				echo -e "\t" >> $name

				if [[ ${line%%' '*} != "void" ]]
				then
					echo -e "\treturn ;" >> $name
				fi

				echo "}"     >> $name
				echo ""      >> $name
			done

			exec 10<&-
		fi

		echo "" 		>> $name
		echo "int main()" 	>> $name
		echo "{" 		>> $name
		echo -e "\t" 		>> $name
		echo -e "\treturn 0;"	>> $name
		echo "}"		>> $name
		echo "" 		>> $name
	fi

	exec 3>&-

	nano $name

	exit 0

else
	# if no file name is given or if too many arguments ar given :
	echo "You have to give at least one arguments, the name of the file" >&2
	exit 1
fi
