#! /bin/bash

echo 'Going to setup, here we go...'
echo '------------------------'

read -p "Run the update script? [yn]" answer
if [[ $answer = y ]] ; then
  echo <password> | sudo -S yum update ;
fi