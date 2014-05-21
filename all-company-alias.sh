#!/bin/sh

# script for creating 'all@company.com' alias for Zarafa

# Install:
# 1. Place script on the zarafa server
# 2. Include aliases file to postfix (main.cf):
#    virtual_alias_maps = hash:/etc/postfix/virtual, hash:/etc/postfix/all-company
# 3. Add this script to cron (once per day will be enough) OR setup watchdog to run this script on every virtual users list change
#

# Removing previous file
rm /etc/postfix/all-company

# Making list of users, leaving only 'username' field (the same as e-mail)
# and cutting first 4 lines (header and Zarafa's SYSTEM account)
zarafa-admin -l | cut -f2 | tail -n +5 | tr '\n' ',' | head --bytes=-2 > /etc/postfix/all-company

# Removing unnecessary e-mails
sed -i 's/service@company.com//g' /etc/postfix/all-company
sed -i 's/info@company.com//g' /etc/postfix/all-company
# Removing double commas
sed -i 's/,,/,/g' /etc/postfix/all-company

# Add alias at the beginning of file
echo "all@company.com\t\t$(cat /etc/postfix/all-company)" > /etc/postfix/all-company

# Proceed with postmap
postmap /etc/postfix/all-company

# Reload postfix configuration
service postfix reload
