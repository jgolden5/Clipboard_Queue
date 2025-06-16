#!/bin/bash
clipboard_queue() {
  for param in "$@"; do
    echo "$param" | pbcopy
    read -n1 -s -p "\"$param\""
    echo
  done
}

alias cq='clipboard_queue'
alias scq='source clipboard_queue.sh'
alias vcq='vim clipboard_queue.sh'
