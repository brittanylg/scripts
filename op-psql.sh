#!/bin/bash

function help() {
	echo
	echo 'This script uses `op` cli to get credentials from a specified item in a 1password account, and uses those credentials to execute a sql file using `psql`.'
	echo
	echo '    -i (required) : the name or ID of the item in 1password (if multiple items share the same name, use the ID here)'
	echo '    -f (required) : the path to the script file being executed'
	echo '    -v            : the name or ID of the vault the credentials are stored in'
	echo '    -h            : help'
}

while getopts "i:f:v:h" option; do
	case "${option}" in
		i)
			i=${OPTARG}
			;;
		f)
			f=${OPTARG}
			;;
		v)
			v=${OPTARG}
			;;
		h)
			help
			exit 0
			;;
		:)
			echo "Error: -${OPTARG} requires an argument"
			help
			exit 0
			;;
		\?)
			echo 'Error: Invalid option'
			help
			exit 0
			;;
	esac
done

function get_op_values() {
	op_str=$(op item get $i --vault "$v" --fields label=server,label=username,label=database)
}

function set_vars() {
	get_op_values || {
		echo 'failed to get values from 1password'
		exit 0
	}
	
	IFS=','

	read -a strarr <<< "$op_str"

	host=${strarr[0]}
	user=${strarr[1]}
	db=${strarr[2]}
}

# if you don't want to enter a vault name every time, you can 
# set that here using either the vault name or vault ID.
if [ -z ${v} ]
then
	v='DEFAULT_VAULT_NAME_ID'
fi

if [ -z ${i} ]
then
	echo 'Error: Expected argument for -i'
	help
	exit 0
else
	set_vars
fi

if [ -z ${f} ]
then
	echo 'Error: Expected argument for -f'
	help
	exit 0
elif [ ! -f $f ];
then
	echo 'Error: File does not exist'
	exit 0
fi

echo
echo 'psql command to run:'
echo "psql -h $host -U $user $db -W -f $f"
echo

read -p 'Do you wish to continue? [y/n] ' -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# echo 'do the scary stuff'
	psql -h $host -U $user $db -W -f $f
fi
