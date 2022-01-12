#!/bin/bash

USER_ID="$(id -u)"
#echo "$USER_ID"

if [[ "${USER_ID}" -eq '0' ]]
then
    read -p "Enter the Username of the Employee who this account is for: "  USER_NAME
    read -p "Enter the Name of the Employee: " NAME
    read -p "Enter the Password for the User Account: " PASSWORD
    useradd -c "${NAME}" -m ${USER_NAME}
    if [[ "${?}" -eq "0" ]]
    then
        echo "${USER_NAME}:${PASSWORD}" | chpasswd
        if [[ "${?}" -eq "0" ]]
        then
            echo "User Account for ${USER_NAME} with Password ${PASSWORD} had been created for ${NAME} on $(hostname) Machine."
        else
            echo "Some Error Occured while initiating the password for the ${USER_NAME}."
            exit 1
        fi
    else
        echo "We encountered some problem creating the account name: ${USER_NAME}."
        exit 1
    fi
else
    echo "You are $(id -un) only ROOT can run this script"
    exit 1
fi
