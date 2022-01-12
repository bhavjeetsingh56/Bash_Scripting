#!/bin/bash

if [[ "${#}" -gt 0 ]]
then
    LOG_FILE="${1}"
    if [[ ! -e "$LOG_FILE" ]]
    then
        echo "Cannot Open ${LOG_FILE}." >&2
        exit 1
    fi

   #For invalid users (Attacker is using usernames which are not configured on the machine)
   INVALID_USERS=$(cat /var/log/auth.log | grep "Failed password" | grep "invalid user" | awk '{print $11, $13}' | sort -k 1 | uniq -c | awk  '{print $1, $2, $3}' OFS=",")
   
    #Echoing the comma seperated values on terminal.
    echo "Count,Username,IP_Address"


   echo "$INVALID_USERS" > Invalid_Users.csv
   awk -F "," '{if ($1 >= 10)
        print $1, $2, $3}' OFS="," Invalid_Users.csv

   #For existing users (Users present on Machine.)
   EXISTING_USERS=$(cat /var/log/auth.log | grep "Failed password" | grep -v "invalid" | awk '{print $9, $11}' | sort -k 1 | uniq -c | awk '{print $1, $2, $3}' OFS=",")
   echo "$EXISTING_USERS" > Existing_Users_failed_login_attempts.csv
   awk -F "," '{if ($1 >= 10)
        print $1, $2, $3}' OFS="," Existing_Users_failed_login_attempts.csv
else
    echo "Usage: ${0} [AUTHD_file]"
    exit 1
fi