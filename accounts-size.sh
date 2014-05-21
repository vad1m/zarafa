#!/bin/sh

# Displaying sizes of user's mailboxes in Zarafa

zarafa-admin -l | cut -f2 | tail -n +5 | while read -r line ; do
    echo "$line\t$(zarafa-admin --details $line | grep size | cut -c 21-)"
done
