
# Utility script to help build html files and projects
#
#
# There are optional arguments :
#
#	- -d : add a documentation tempalte at the start of the file
#	- -j : change the document from html to jinja
#
#
# It will :
#	- create a file
#	- fill it with a template
#	- open nano
#
#--------------------------------------------------------------------------------
#
# Made by :
#	- Gély Léandre :: https://github.com/Zaynn-lea
#
# Date :
#	started      :  18 / 01 / 25
#	last updated :  18 / 01 / 25


#!/bin/bash


if [[ $# -gt 0 ]]
then

	# Options variables

	has_doc=0
	is_jinja=0


	ext='.html'


	# Parser to take care of the parameters
	# single-char optins and standards parameters, in ths order

	for arg in "$@"
	do
		if [[ ${arg:0:1} = '-' ]]
		then
			# Single-character options :

			for (( i=1 ; i<${#arg} ; i++ ))
			do
				case ${arg:$i:1} in
					(d) has_doc=1  ;;
					(j) is_jinja=1 ;;
				esac
			done
		else
			# normal arguments and parameters

			name=$arg
		fi
	done


	# Taking care of the name :

	if [[ $is_jinja -eq 1 ]]
	then
		ext='.jinja'
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


	# +-----------------+
	# |   Main Script   |
	# +-----------------+

	touch $name

	exec 3> $name


	if [[ $has_doc -eq 1 ]]
	then
		# Documentation template

		today=$(date +%d' / '%m' / '%y)

		echo ""     >> $name
		echo "<!--" >> $name
		echo ""	    >> $name
		echo ""     >> $name
		echo "----------------------------------------------------------------------------------------------------------------------------" >> $name
		echo ""			 	  >> $name
		echo "Made by :"	 	  >> $name
		echo -e "\t- "$USER		  >> $name
		echo ""				  >> $name
		echo "Date :"			  >> $name
		echo -e "\tstarted     :  "$today >> $name
		echo -e "\last updated :  "$today >> $name
		echo "-->"			  >> $name
		echo ""				  >> $name
	fi


	# Main template :

	echo ""			  >> $name
	echo "<!DOCTYPE html>" 	  >> $name
	echo ""			  >> $name
	echo ""			  >> $name
	echo "<html lang=\"en\">" >> $name
	echo ""			  >> $name
	echo "<head>"		  >> $name
	echo ""			  >> $name

	echo -e "\t<meta charset=\"UTF-8\">" 		       >> $name
	echo -e "\t<meta name=\"author\" content=\"${USER}\">" >> $name
	echo -e "\t"					       >> $name
	echo -e "\t<title>${name%%.*}</title>"

	echo ""	       >> $name
	echo "</head>" >> $name
	echo ""        >> $name
	echo ""        >> $name
	echo "<body>"  >> $name
	echo ""	       >> $name

	echo -e "\t<header>"  >> $name
	echo -e "\t\t" 	      >> $name
	echo -e "\t</header>" >> $name

	echo "" >> $name
	echo "" >> $name

	echo -e "\t<main>"  >> $name
	echo -e "\t\t"	    >> $name
	echo -e "\t</main>" >> $name

	echo "" >> $name
	echo "" >> $name

	echo -e "\t<footer>"  >> $name
	echo -e "\t\t"	      >> $name
	echo -e "\t</footer>" >> $name

	echo ""	       >> $name
	echo "</body>" >> $name
	echo ""        >> $name
	echo "</html>" >> $name
	echo ""        >> $name


	exec 3>&-

	nano $name

	exit 0

else
	# if no file name is given or if too many arguments are given
	echo "You have to give at least one arguments, the name of the file" >&2
	exit 1
fi
