#! /bin/bash

echo 'Please Enter your password to access superuser'
sudo su

echo 'Now going to setup, here we go...'
echo '------------------------------------'

read -p "Run the update script? [yn]" answer
if [[ $answer = y ]] ; then
  yum update ;
fi