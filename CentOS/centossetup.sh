#! /bin/bash

if [[ $UID -ne 0 ]]; then sudo "$0"; exit 0; fi
echo 'Now going to server setup, here we go...'
echo '------------------------------------'

read -p "Run the update script? [yn]" answer
if [[ $answer = y ]] ; then
  yum update ;
fi

read -p "Change host file contents? [yn]" answer
if [[ $answer = y ]] ; then
  read -p "Static IP Address Desired: " ipaddressinput
  read -p "Domain desired: " domainnameinput
  read -p "Server name desired: " servernameinput
do
  echo -n "Please enter the desired Static IP Address for the server on LAN: "
  stty -echo
  read -r ipaddressinput
  echo
  echo -n "Please neter your desired server name for the server: "
  read -r servernameinput
  stty echo
  echo
  echo -n "Please neter your desired domain for the server: "
  read -r domainnameinput
  stty echo
done
> /etc/hosts
echo "127.0.0.1   localhost" >> /etc/hosts
echo "127.0.1.1 	$servernameinput.$domainnameinput.local 	$servernameinput" >> /etc/hosts
echo "$ipaddressinput	$servernameinput.$domainnameinput.local 	$servernameinput" >> /etc/hosts
echo "$servernameinput.$domainnameinput.local" > /etc/hostname

echo "Server name has been set to:"
hostname -s
echo "Server full hostname has been set to:"
hostname -f
echo "Server is currently set for this network config:"
ifconfig
fi

