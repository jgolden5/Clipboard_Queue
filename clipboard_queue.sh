#!/bin/bash
clipboard_queue() {
  local selection_index=1;
  while (( selection_index <= "$#" )); do
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
}

alias cq='clipboard_queue'
alias scq='source clipboard_queue.sh'
alias vcq='vim clipboard_queue.sh'
