#!/bin/bash

system="$(uname -a)"
if [[ $system =~ Darwin ]]; then
  search_command="open"
elif [[ $system =~ Linux ]]; then
  search_command="xdg-open"
else
  search_command="explorer"
fi

clipboard_queue() {
  local selection_index=1;
  local -a lines
  if [[ $# == 1 && -f $1 ]]; then
    mapfile -t lines < "$1"
    number_of_lines=$(wc -l $1 | awk '{ print $1 }' | sed 's/ //g')
  else
    lines=("$@")
    number_of_lines=$#
  fi
  while (( selection_index <= "${#lines[@]}" )); do
    clear
    print_lines "${lines[@]}"
    read -n1 -s -p "Hit 'n' for next, 'p' for previous, 'j' to jump to a line, 'g' to google, or 'q' for quit" user_selection
    case $user_selection in
      g)
        google_line
        ;;
      j)
        jump_to_line
        ;;
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
        sleep 0.3
        ;;
    esac
  done
  echo
}

google_line() {
  local i=$(($selection_index - 1))
  local line="${lines[$i]}"
  if [[ "$line" =~ ^https:// ]]; then
    $search_command "$line"
  else
    $search_command "http://www.google.com/search?q=$line"
  fi
}

jump_to_line() {
  clear
  print_lines_with_numbers
  read -p "Which line would you like to jump to? " n
  echo
  if [[ "$n" ]]; then
    if [[ $n -lt 1 ]]; then
      echo "Index was too low. Jumping to minimum index"
      sleep 0.3
      selection_index=1
    elif [[ $n -gt "$number_of_lines" ]]; then
      selection_index="${#lines[@]}"
    else
      selection_index=$n
    fi
  else
    echo "Ok, no jumping for now then" && sleep 0.3
  fi
}

print_lines() {
  local i=1
  for line in "${lines[@]}"; do
    if [[ $i == $selection_index ]]; then
      echo ">> $line"
      echo "$line" | pbcopy
    else
      echo "$line"
    fi
    ((i++))
  done
}

print_lines_with_numbers() {
  local line_number=1
  for line in "${lines[@]}"; do
    echo "$line_number: $line"
    ((line_number++))
  done
}

alias cq='clipboard_queue'
alias scq='source clipboard_queue.sh'
alias vcq='vim clipboard_queue.sh'
