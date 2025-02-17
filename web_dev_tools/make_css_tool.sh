
# Utility script to help build html files and projects
#
#
# There are optional arguments :
#	- the name of the futur file, by default it is " style.css "
#
#	- -d : add a documetation template at the start of the file
#
#	- --is-connected-html : save the name into a tmp file to call it from another script
#
#
# it will :
#	- create aaa file
#	- fill it with a template
#	- open nano
#
#--------------------------------------------------------------------------------
#
# Made by :
#	- Gély Léandre :: https://github.com/Zaynn-lea
#
# Date :
#	started      :  19 / 01 / 25
#	last updated :  13 / 02 / 25


#!/bin/bash


has_doc=0

is_connected_html=0

has_name=0

ext='.css'


# Parser to take care of the parameters, if any
# takes care of multi-char options, single-char options and standards parameters, in this order

for arg in "$@"
do
	if [[ ${arg:0:2} = '--' ]]
	then
		# Multi_characters options :

		case ${arg:2} in
			(is-connected-html) is_connected_html=1 ;;
		esac
	elif [[ ${arg:0:1} = '-' ]]
	then
		# Single-character options :

		for (( i=1 ; i < ${#arg} ; i++ ))
		do
			case ${arg:$i:1} in
				(d) has_doc=1 ;;
			esac
		done
	else
		name=$arg
		has_name=1
	fi
done


# Dealing with the possibility of the name being already taken

if [[ $has_name -eq 0 ]]
then
	name="style"
fi

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


# if we are called from another script, we give out the name of the file to pipe it

if [[ $is_connected_html -eq 1 ]]
then
	echo $name
fi


# +-------------------+
# |   Main Script :   |
# +-------------------+


touch $name

exec 3>& $name


if [[ has_doc -eq 1 ]]
then
	# documentation template

	today=$(date +%d' / '%m' /'%y)

	echo ""   >> $name
	echo "/*" >> $name
	echo ""   >> $name
	echo ""   >> $name
	echo "----------------------------------------------------------------------------------------------------------------------------" >> $name
	echo ""				     >> $name
	echo "Made by :"		     >> $name
	echo -e "\t- "$USER		     >> $name
	echo ""				     >> $name
	echo "Date :"			     >> $name
	echo -e "\tstarted      :  "$today   >> $name
	echo -e "\tlast updated :  "$today   >> $name
	echo "*/"			     >> $name
	echo ""				     >> $name
fi


# Main style template

echo "" >> $name

echo "/* css reset */" 		     >> $name
echo ""				     >> $name
echo "* {"			     >> $name
echo -e "\tmargin:      0;"	     >> $name
echo -e "\tpadding:     0;"	     >> $name
echo -e "\tbox-sizzing: border-box;" >> $name
echo "}"			     >> $name

echo "" >> $name
echo "" >> $name

echo "/***************\\"	 >> $name
echo "|   Variables   |"	 >> $name
echo "\\***************/"	 >> $name
echo ""				 >> $name
echo ":root {"			 >> $name
echo -e "\t--BackgroundColor: ;" >> $name
echo -e "\t--TextColor: ;"	 >> $name
echo "}"			 >> $name

echo "" >> $name
echo "" >> $name

echo "/*********************\\" >> $name
echo "|   General styling   |"  >> $name
echo "\\*********************/" >> $name
echo ""			        >> $name
echo "html {" 			>> $name
echo -e "\t" 			>> $name
echo "}" 			>> $name
echo "" 			>> $name
echo "body {" 			>> $name
echo -e "\t" 			>> $name
echo "}" 			>> $name


echo "" >> $name
echo "" >> $name

echo "/********************\\" >> $name
echo "|   Header styling   |"  >> $name
echo "\\********************/" >> $name
echo ""			       >> $name
echo "header {" 	       >> $name
echo -e "\t"		       >> $name
echo "}" 		       >> $name

echo "" >> $name
echo "" >> $name

echo "/******************\\" >> $name
echo "|   Main styling   |"  >> $name
echo "\\******************/" >> $name
echo ""			     >> $name
echo "main {" 		     >> $name
echo -e "\t" 		     >> $name
echo "}" 		     >> $name

echo "" >> $name
echo "" >> $name

echo "/********************\\" >> $name
echo "|   Footer styling   |"  >> $name
echo "\\********************/" >> $name
echo ""			       >> $name
echo "footer {" 	       >> $name
echo -e "\t" 		       >> $name
echo "}" 		       >> $name

echo "" >> $name


exec 3>&-

if [[ $is_connected_html -ne 1 ]]
then
	nano $name
fi


exit 0

