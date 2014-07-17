#! /bin/bash

if [[ $UID -ne 0 ]]; then sudo "$0"; exit 0; fi
echo 'Now going to server setup, here we go...'
echo '------------------------------------'

read -p "Run the update script? [yn]" answer
if [[ $answer = y ]] ; then
  yum update ;
fi

read -p "Run the update script? [yn]" answer
if [[ $answer = y ]] ; then
  yum update ;
fi