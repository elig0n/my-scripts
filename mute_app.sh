#!/bin/bash
# List or toggle mute on pulseaudio clients by process name

main() { 
    local action=toggle
    while getopts :l option; do 
        case "$option" in 
		  		l) list ; exit 0 ; ;;
            ?) echo "invalid option: -$OPTARG" ; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))
	  
    local pid=$(pidof "$1")
    if [[ -z "$pid" ]]; then
        echo "error: no running processes for: $1" >&2
    elif [[ "$1" ]]; then
        toggle "$1"
    else
        echo "specify an application name" 
		  exit 1 
    fi
}

list() {
	pacmd list-sink-inputs | gawk '
	$1 == "application.name" {name = $3}
	$1 == "application.process.binary" {bin = $3}
	$1 == "application.process.id" {id = $3} 
	{ 
		if (name != "" && bin != "" && id != "")
			{
				gsub("\"","",name) 
				gsub("\"","",bin) 
				gsub("\"","",id) 
				printf "%-20s %-20s %-20s \n", name, bin, id;
				bin = ""; id = ""; name = "";
		   } 
	}
	' 
}

toggle() {
	 local pids=$(pidof "$1")
	 for pid in $pids; do 
		  local index=$(get_index $pid)
		  [[ "$index" ]] && pactl set-sink-input-mute $index toggle		   
	 done
}

get_index() {
	 pacmd list-sink-inputs | \
	 gawk -v pid=$1 '
	 $1 == "index:" {idx = $2} 
	 $1 == "application.process.id" && $3 == "\"" pid "\"" {print idx; exit}
	 '
}

main "$@"
