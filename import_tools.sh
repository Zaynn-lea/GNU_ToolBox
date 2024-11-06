
# This script contains all aliases and shortcut, ready to be added to your bash
#
# Thoses aliases are short and explicit, the goal is to turn them into commands
#
#
# All you have to do is add the following in your .bashrc :
#	~/GNU_ToolBox/import_tools.sh
# followed by your options
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
#	last updated :  06 / 11 / 24


#!/bin/bash


has_shorts=0

# Taking care of the options (-something)

while getopts s o
do
	case  $o in
		(s) has_shorts=1;;

		(*) usage
	esac
done


# +------------------+
# |   Main script :  |
# +------------------+

# Scripts tool aliases :

alias "mkmakef"=${PWD}'/make_makefile_tool.sh'

alias "mkmatlab"=${PWD}'/make_matlab_tool.sh'

alias "mkscript"=${PWD}'/make_script_tool.sh'


# short aliases :

if [[ has_shorts -eq 1 ]]
then
	alias "mkmkf"=mkmakef
	alias "mkml"=mkmatlab
	alias "mksh"=mkscript
fi
