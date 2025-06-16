#!/bin/bash
clipboard_queue() {
  for (( selection_index = 1; selection_index <= $#; selection_index++ )); do
    echo "Selection Index = $selection_index"
    i=1
    clear
    for param in "$@"; do
      if [[ $i == $selection_index ]]; then
        echo ">> $param"
        echo "$param" | pbcopy
      else
        echo "$param"
      fi
      ((i++))
    done
    read -n1 -s -p "Hit 'n' for next"
  done
}

alias cq='clipboard_queue'
alias scq='source clipboard_queue.sh'
alias vcq='vim clipboard_queue.sh'
