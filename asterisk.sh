#!/bin/bash
# by izabera

readpasswd () {
  local REPLY i IFS= LANG=C tty asterisks
  tty=$(stty -g)
  # bash sucks
  stty -echo raw
  trap 'stty "$tty"' return
  while
    asterisks=${password//?/*}
    printf '\r%s\e[K\r' "$asterisks"
    ((i)) && printf '\e[%dC' "$i"
    read -rn1 -d ''
  do
    if [[ $REPLY = $'\x1b' ]]; then # first check arrows/del
      read -rn1 -d ''
      if [[ $REPLY = '[' ]]; then
        read -rn1 -d ''
        case $REPLY in
          D) ((i -= i > 0));; # left arrow
          C) ((i += i <= ${#password}-1));; # right arrow
          3) read -rn1 -d ''
             if [[ $REPLY = '~' ]]; then # del
               password=${password:0:i}${password:i+1}
             else continue
             fi ;;
          *) continue
        esac
      elif [[ $REPLY = O ]]; then # some terminals use ^[OC instead of ^[[C
        read -rn1 -d ''
        case $REPLY in
          D) ((i -= i > 0));; # left arrow
          C) ((i += i <= ${#password}));; # right arrow
          *) continue
        esac
      else continue
      fi
    elif [[ $REPLY = [$'\b\177'] ]]; then # backspace
      if ((i)); then
        password=${password:0:i-1}${password:i}
        ((i--))
      fi
    elif [[ $REPLY = [$'\4\r\n'] ]]; then # ^D \r \n
      return
    else
      password=${password:0:i}$REPLY${password:i}
      ((i++))
    fi
  done
}
 
trap 'stty sane' exit
readpasswd
printf '\ryour password is <%s>\e[K\n' "$password"
