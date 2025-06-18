#!/bin/bash
clipboard_queue() {
  local selection_index=1;
  local lines=
  local number_of_lines=
  if [[ $# == 1 && -f $1 ]]; then
    lines=$(cat $1)
    number_of_lines=$(wc -l $1 | awk '{ print $1 }' | sed 's/ //g')
  else
    lines=$@
    number_of_lines=$#
  fi
  while (( selection_index <= "$number_of_lines" )); do
    i=1
    clear
    print_lines "${lines[@]}"
    read -n1 -s -p "Hit 'n' for next, 'p' for previous, or 'q' for quit" user_selection
    case $user_selection in
      n)
        ((selection_index++))
        ;;
      p)
        if [[ $selection_index -gt 1 ]]; then
          ((selection_index--))
        fi
        ;;
      q)
        echo
        echo "Quitting Clipboard Queue..."
        return 1
        ;;
      *)
        echo
        echo "Input not recognized, please try again"
        sleep 0.5
        ;;
    esac
  done
  echo
}

print_lines() {
  for line in ${lines[@]}; do
    if [[ $i == $selection_index ]]; then
      echo ">> $line"
      echo "$line" | pbcopy
    else
      echo "$line"
    fi
    ((i++))
  done
}

alias cq='clipboard_queue'
alias scq='source clipboard_queue.sh'
alias vcq='vim clipboard_queue.sh'
