
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
#
#--------------------------------------------------------------------------------
#
# Made by :
#	- Gély Léandre :: https://github.com/Zaynn-lea
#
# Date :
#	started      :  06 / 11 / 24
#	last updated :  13 / 11 / 24


#!/bin/bash


has_shorts=0

here='~'

# Taking care of the options (-something)

# Same parser as in pretty_clear_tool.sh
for arg in $@
do
	if [[ ${arg:0:1} = '-' ]]
	then
		for (( i=1 ; i<${arg#} ; i++ ))
		do
			case ${arg:$i:1} in
				(s) has_shorts=1;;
			esac
		done
	else
		here='~/'$arg
	fi
done


# +------------------+
# |   Main script :  |
# +------------------+

# Scripts tool aliases :

alias "mkc"=${here}'/make_C_tool.sh'

alias "mkmakef"=${here}'/make_makefile_tool.sh'

alias "mkmatlab"=${here}'/make_matlab_tool.sh'

alias "mkscript"=${here}'/make_script_tool.sh'

alias "pclear"=${here}'/pretty_clear_tool.sh'


# short aliases :

if [[ has_shorts -eq 1 ]]
then
	alias "mkmkf"=mkmakef
	alias "mkml"=mkmatlab
	alias "mksh"=mkscript
	alias "pcls"=pclear
fi

