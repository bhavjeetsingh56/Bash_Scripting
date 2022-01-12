#!/bin/bash



ARCHIVE_DIR='/archive'
#This script disables, deletes, and/or archives user on the local system.

usage(){
    #Display the usage and index.
    echo "Usage: ${0} [-dra] USER [USERNAME]....."
    echo "Disbale a local linux account." >&2
    echo "  -d Deletes accounts instead of disabling them." >&2
    echo "  -r Removes the home directory associated with the account(s)." >&2
    echo "  -a Creates an archive of the home directory associated with the account(s)." >&2
    exit 1
}

#Make sure the script is being executed with super privileges.
if [[ "${UID}" -ne '0' ]]
then
    echo "Please run with sudo as a root." >&2
    exit 1
fi

#parse the command line options
while getopts dra OPTION
do
    case $OPTION in
    d)
        DELETE_USER='true' ;;
    r)
        REMOVE_OPTION='-r' ;;
    a)
        ARCHIVE='true' ;;
    ?)
        usage ;;
    esac
done

#Remove the options while leaving the user accounts.
shift "$(( OPTIND - 1 ))"


#if the user doesn't supply at lease one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
    usage
fi

#Loop through all the usernames supplied as arguments.
for USERNAME in "${@}"
do
    echo "Processing User: ${USERNAME}."

    #MAKE SURE THE UID OF THE ACCOUNT IS ATLEAST 1000.
    USERID=$(id -u ${USERNAME})
    if [[ "${USERID}" -lt 1000 ]]
    then
        echo "Refusing to remove the ${USERNAME} account with the UID ${UID}." >&2
        exit 1
    fi

    #Create an archive if requested to do so.
    if [[ "${ARCHIVE}" == 'true' ]]
    then
        #Make sure the ARCHIVE_DIR already exists.
        if [[ ! -d "$ARCHIVE_DIR" ]]
        then
            echo "Creating $ARCHIVE_DIR directory."
            mkdir -p ${ARCHIVE_DIR}
            if [[ "${?}" -ne 0 ]]
            then
                echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
                exit 1
            fi
        fi


        #Archive the user's home directory and move it to into the ARCHIVE_DIR.
        HOME_DIR="/home/${USERNAME}"
        ARCHIVE_FILE="${ARCHIVE_DIR}/$USERNAME.tar"
        if [[ -d "$HOME_DIR" ]]
        then
            echo "Archiving the $HOME_DIR to $ARCHIVE_FILE"
            tar -zcvf $ARCHIVE_FILE $HOME_DIR &> /dev/null
            if [[ "${?}" -ne 0 ]]
            then
                echo "Could not create ${ARCHIVE_FILE}." >&2
                exit 1
            fi
        else
            echo "$HOME_DIR does not exist or is not a directory." >&2
            exit 1
        fi
    fi

    #To delete the user or not.
    if [[ "${DELETE_USER}" == "true" ]]
    then
        #Delete the user
        userdel $REMOVE_OPTION $USERNAME

        #Check to see if the userdel command executed successfully.
        if [[ "${?}" -ne 0 ]]
        then
            echo "We encountered some error while deleting the given user $USERNAME." >&2
            exit 1
        else
            echo "The user account $USERNAME was deleted."
        fi

    else
        chage -E 0 $USERNAME
        #Check to see if the chage command executed successfully.
        if [[ "${?}" -ne 0 ]]
        then
            echo "We encountered some error while disabling the given user $USERNAME." >&2
            exit 1
        else
            echo "The user account $USERNAME was disabled." >&2
        fi
    fi
done

exit 0

