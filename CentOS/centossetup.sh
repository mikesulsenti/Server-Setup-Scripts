#! /bin/bash

if [[ $UID -ne 0 ]]; then sudo "$0"; exit 0; fi
echo 'Now going to server setup, here we go...'
echo '------------------------------------'

read -p "Run the update script and add EPEL Repo? [yn]" answer
if [[ $answer = y ]] ; then
  wget http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
  ls *.rpm
  yum -y install epel-release-7-0.2.noarch.rpm
  yum update
  echo 'Installing htop...'
  yum -y install htop ;
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
echo "127.0.0.1   localhost" > /etc/hosts
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

read -p "Add VNC server? [yn]" answer
if [[ $answer = y ]] ; then
	yum -y groupinstall Desktop
	yum -y install gnome-core xfce4 firefox
	yum -y install tigervnc-server
	service vncserver start
	service vncserver stop
	chkconfig vncserver on
	wget http://pkgs.repoforge.org/x11vnc/x11vnc-0.9.13-1.el7.rf.x86_64.rpm
	ls *.rpm
    yum -y install x11vnc-0.9.13-1.el7.rf.x86_64.rpm
    mkdir /root/.vnc/
    x11vnc -storepasswd /root/.vnc/passwd
    vncpassword
    startx
    service vncserver start
	systemcl enable vncserver.service
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

read -p "Configure a RAID Array? [yn]" answer
if [[ $answer = y ]] ; then
  fdisk -l
  read -p "Drive 1: " drive1
  read -p "Drive 2: " drive2
  read -p "Drive 3: " drive3
  read -p "Drive 4: " drive4
do
  echo -n "Please enter Drive 1: "
  stty -echo
  read -r drive1
  echo
  echo -n "Please enter Drive 2: "
  read -r drive2
  stty echo
  echo
  echo -n "Please enter Drive 3: "
  read -r drive3
  stty echo
  echo
  echo -n "Please enter Drive 4: "
  read -r drive4
  stty echo
done
mdadm --create /dev/md0 --chunk=256 --level=10 -p f2 --raid-devices=4 /dev/$device1 /dev/$device2 /dev/$device3 /dev/$device4 --verbose
mdadm --detail --scan --verbose > /etc/mdadm.conf
fi