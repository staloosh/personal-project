#!/bin/bash
## This script is used to filter out journalctl logs for the k3s service, searching and printing for the error messages

## Variable definition
LOG_FILE="journal.log"
OUTPUT="output.txt"
RESULT="result.txt"

## Define function to parse logs
parser() {
    echo " -------------------------------------- "
    echo -e "\e[91m You chose $word, let's see the output \e[0m"
    echo " -------------------------------------- "
    grep  $word ${LOG_FILE} > ${OUTPUT} 
    if [ $? -eq 0 ]; then
        awk -F 'msg=' '$2{print $2}' ${OUTPUT} > ${RESULT}
        cat ${RESULT}
        exit 0
    else
        echo "error processing request"
        exit 1
    fi
}

## Multi-choice menu
PS3='Choose what keyword you are looking for in the journalctl log: '
keywords=("error" "failed" "quit")
select word in "${keywords[@]}"; do
    case $word in
    "error")
        parser
        ;;
    "failed")
        parser
        ;;
    "quit")
        echo "I see you don't want to filter logs today, goodbye"
        exit 0
        ;;
    *) echo "invalid option chosen, please enter the digit not the word" ;;
    esac
done
