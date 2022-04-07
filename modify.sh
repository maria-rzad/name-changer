#!/bin/bash
name=$(basename $0)

up_arg=0 	# uppercase mode
low_arg=0	# lowercase mode
rec_arg=0	# recursion mode

sed_pattern=""

error_msg()
{
	echo "	$name: error: $1" 1>&2
	echo "	enter $name -h for help" 1>&2
	exit 1
}

rename()
{
	if [ $rec_arg -eq 1 ] && [ -d "$1" ] 	# rename all contents of a directory
	then
		cd "$1"
		for file in *
		do
			rename "$file"
		done
		cd ..
	fi
	if [ -f "$1" ] && [[ "$1" == *.* ]]	# rename file with extension
	then
		name=${1%.*}
		ext=".${1##*.}"
	else					# rename file without extension
		name="$1"
		ext=""
	fi
	new_name="$(echo $name | sed "$sed_pattern")$ext"
	if [ "$new_name" != "$1" ] 
	then
		if [ -e "$new_name" ]
		then
			echo "	unable to rename '$1', file '$new_name' already exists" 1>&2
		else
			mv "$1" "$new_name"
		fi
	fi
}

count_parameters()
{
	if [ $1 -eq 0 ]
	then
		error_msg "not enough parameters"
	fi
}

count_parameters $#

if [ "$1" = "-h" ] 	# print help message
then
	if [ -n "$2" ]
	then
		error_msg "no parameters allowed after -h"
	else
	cat<<EOT 1>&2

	usage:
		$name [-r] [-l|-u] <dir/file_names...>
		$name [-r] <sed pattern> <dir/file_names...>
		$name [-h]

EOT
	fi
	exit 1
fi

while true
do
	case "$1" in
		-r) rec_arg=1; shift;;
		-l) low_arg=1; shift;;
		-u) up_arg=1; shift;;
		-*) error_msg "option $1 does not exist";;
		*) break;;
	esac
done

count_parameters $#

if [ $low_arg -eq 1 ] && [ $up_arg -eq 1 ]
then
	error_msg "-u and -l cannot be used at the same time"
	exit 1
elif [ $low_arg -eq 0 ] && [ $up_arg -eq 0 ]
then
	if [[ $1 != s/*/*/* ]]
	then
		error_msg "incorrect sed command"
	fi
	sed_pattern="$1" 	# set custom sed pattern
	shift
else
	if [ $low_arg -eq 1 ]
	then
		sed_pattern="s/[A-Z]/\L&/g"
	else
		sed_pattern="s/[a-z]/\U&/g"
	fi
fi

count_parameters $#

while [ -n "$1" ]	# rename files
do
	if [ -f "$1" ] || [ -d "$1" ]
	then
		rename "$1"
	else
		echo "	unable to rename '$1', such file does not exist" 1>&2
	fi
	shift
done
