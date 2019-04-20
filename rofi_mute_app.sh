#!/bin/bash 
# rofi script. requires mute_app.sh 

if [ -z $@ ]
	then 
	function get_audible_programs() 
	{ 
		exec mute_app.sh -l
	}

	echo ; get_audible_programs
else
	PROG=$@

	if [ -n "${PROG}" ] 
	then
		prog_name=$(echo ${PROG}  | cut -d' ' -f2)
		exec mute_app.sh $prog_name
	fi
fi

 
