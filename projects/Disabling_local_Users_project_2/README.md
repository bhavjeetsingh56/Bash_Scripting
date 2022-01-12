The script:

1) Is named "add-new-local-user.sh".

2) Enforces that it be executed with superuser (root) privileges. If the script is not executed with superuser privileges it will not attempt to create a user 
and returns an exit status of 1.

3) Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line and returns an exit status of 1.

4) Uses the first argument provided on the command line as the username for the account.  Any remaining arguments on the command line will be treated as 
the comment for the account.

5) Automatically generates a password for the new account.

6) Informs the user if the account was not able to be created for some reason.  If the account is not created, the script is to return an exit status of 1.

7) Displays the username, password, and host where the account was created.  This way the help desk staff can copy the output of the script in order 
to easily deliver the information to the new account holder.
