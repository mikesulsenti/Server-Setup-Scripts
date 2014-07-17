#! /bin/bash

echo 'Please Enter your password to access superuser'
if [[ $UID -ne 0 ]]; then sudo "./test.sh"; exit 0; fi
echo 'Now going to setup, here we go...'
echo '------------------------------------'

read -p "Run the update script? [yn]" answer
if [[ $answer = y ]] ; then
  yum update ;
fi