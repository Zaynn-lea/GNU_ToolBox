
# This script contains all aliases and shortcuts, ready to be added to your bash
#
# Thoses aliases are short and explicit, the goal is to turn them into commands
#
# This script requier to know in which directory it is from your ~
# This script requer to be in the same repository as the other tools
#
#
# All you have to do is add the following in your .bashrc :
#	source {your path here}/GNU_ToolBox/import_tools.sh {your path here}
#
# Your options can go pretty much everyhere you wish
#
#
# Opions :
#
#	- -s : add shorter aliases
#	- -a : add more aliases if you don't want to use the options of the new commands
#
#--------------------------------------------------------------------------------
#
# Made by :
#	- Gély Léandre :: https://github.com/Zaynn-lea
#
# Date :
#	started      :  06 / 11 / 24
#	last updated :  20 / 11 / 24


#!/bin/bash


# Options variables

has_shorts=0
has_all=0

here='~'

# Parser to take care of the parameters
# takes care of multi-char options, single-char options and standards parameters, in this order

for arg in "$@"
do
	if [[ ${arg:0:1} = '-' ]]
	then
		for (( i=1 ; i<${#arg} ; i++ ))
		do
			case ${arg:$i:1} in
				(s) has_shorts=1 ;;
				(a) has_all=1    ;;
			esac
		done
	else
		here='~/'$arg
	fi
done


# +------------------+
# |   Main script :  |
# +------------------+

# Scripts tools :

mkc=${here}'/make_C_tool.sh'

mkmakef=${here}'/make_makefile_tool.sh'

mkmatlab=${here}'/make_matlab_tool.sh'

mkscript=${here}'/make_script_tool.sh'

pclear=${here}'/pretty_clear_tool.sh'


# Aliases :

alias "mkc"=$mkc
alias "mkcpp"=${mkc}' --cpp'

alias "mkmakef"=$mkmakef

alias "mkmatlab"=$mkmatlab

alias "mkscript"=$mkscript

alias "pclear"=$pclear


# Short aliases :

if [[ has_shorts -eq 1 ]]
then
	alias "mkmkf"=$mkmakef
	alias "mkml"=$mkmatlab
	alias "mksh"=$mkscript
	alias "pcls"=$pclear
fi


# All aliases if you don't wanna use options :

if [[ has_all -eq 1 ]]
then
	alias "mkcd"=${mkmatlab}' -d'
	alias "mkcm"=${mkmatlab}' -m'
	alias "mkcppd"=${mkmatlab}' --cpp -d'
	alias "mkcppm"=${mkmatlab}' --cpp -m'

	alias "mkmatlabd"=${mkmatlab}' -d'
	alias "mkmatlabf"=${mkmatlab}' -f'

	alias "mkscriptd"=${mkscript}' -d'

	alias "pcleara"=${pclear}' -a'
	alias "pclearg"=${pclear}' -g'
	alias "pclearl"=${pclear}' -l'
	alias "pclearm"=${pclear}' -m'
fi
