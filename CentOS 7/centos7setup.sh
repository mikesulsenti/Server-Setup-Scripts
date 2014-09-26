#! /bin/bash

if [[ $UID -ne 0 ]]; then sudo "$0"; exit 0; fi
echo 'Now going to server setup, here we go...'
echo '------------------------------------'

read -p "THIS SCRIPT WAS MADE AND TESTED FOR *CENTOS 7*!!
Are you sure you want to continue? [yn]" answer
if [[ $answer = y ]] ; then
  echo "Okay..." ;
fi

read -p "This script will be able to install modularly the following things
Update and install RHEL repo and htop
Add Users (Up to 3 currently)
LAMP stack
Install phpmyadmin
hosts and hostname files
Create VNC server
Configure email SSMTP
Configure Raid Array (Linux RAID 10 for 4 drives)
Samba confirguration for the RAID
Install and configure webmin
Configure firewall
Implement a dynamic MOTD
So are you ready to continue? [yn]" answer
if [[ $answer = y ]] ; then
  echo "Okay, let's go..." ;
fi

read -p "Run the update script and add EPEL Repo to install htop? [yn]" answer
if [[ $answer = y ]] ; then
  wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
  ls *.rpm
  yum -y install epel-release-7-2.noarch.rpm
  yum -y update
  echo 'Installing htop...'
  yum -y install htop ;
fi

read -p "Add user? [yn]" answer
if [[ $answer = y ]] ; then
  read -p "Please enter the desired username: " userinput
  useradd $userinput
  passwd $userinput
read -p "Add user to sudoers? [yn]" answer
if [[ $answer = y ]] ; then
  adduser $userinput sudo ;
fi
read -p "Add another user? [yn]" answer
if [[ $answer = y ]] ; then
  read -p "Please enter the desired username: " userinput2
  useradd $userinput2
  passwd $userinput2
read -p "Add user to sudoers? [yn]" answer
if [[ $answer = y ]] ; then
  adduser $userinput2 sudo ;
fi
read -p "Add another user? [yn]" answer
if [[ $answer = y ]] ; then
  read -p "Please enter the desired username: " userinput3
  useradd $userinput3
  passwd $userinput3
read -p "Add user to sudoers? [yn]" answer
if [[ $answer = y ]] ; then
  adduser $userinput3 sudo ;
fi
fi
fi
fi

read -p "Setup LAMP stack? [yn]" answer
if [[ $answer = y ]] ; then
  yum -y update
  yum -y install httpd
  systemctl start httpd.service
  yum -y install mariadb-server mariadb
  ssystemctl start mariadb
  mysql_secure_installation
  yum -y install php php-mysql
  yum -y install php-*
  systemctl enable httpd.service
  systemctl enable mariadb.service ;
fi

read -p "Setup phpMyAdmin? [yn]" answer
if [[ $answer = y ]] ; then
  echo 'For the server selection, choose apache2. Note - If you do not hit SPACE to select Apache the installer will not move the necessary files during installation. Hit SPACE, TAB, and then ENTER to select Apache'
  echo 'Select yes when asked whether to use dbconfig-common to set up the database'
  yum -y update
  yum -y install phpmyadmin
  vi /etc/httpd/conf.d/phpMyAdmin.conf
  systemctl restart httpd.service ;
fi

read -p "Change host file contents? [yn]" answer
if [[ $answer = y ]] ; then
  read -p "Please enter the desired Static IP Address for the server on LAN: " ipaddressinput
  read -p "Please neter your desired domain name for the server: " domainnameinput
  read -p "Please neter your desired name for the server: " servernameinput
echo "127.0.0.1   localhost" > /etc/hosts
echo "127.0.1.1   $servernameinput.$domainnameinput.local   $servernameinput" >> /etc/hosts
echo "$ipaddressinput $servernameinput.$domainnameinput.local   $servernameinput" >> /etc/hosts
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
  yum -y groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts"
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
fi

read -p "Configure SAMBA for the RAID Array? [yn]" answer
if [[ $answer = y ]] ; then
  fdisk -l
  read -p "Set Main Network Drive Share Name: " sambadir
echo "" >> /etc/samba/smb.conf
echo "/media/raid10/$sambadir" >> /etc/samba/smb.conf
echo "valid users = @users" >> /etc/samba/smb.conf
echo "force group = users" >> /etc/samba/smb.conf
echo "create mask = 0660" >> /etc/samba/smb.conf
echo "directory mask = 0771" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
echo "read only = No" >> /etc/samba/smb.conf
echo "Added share, restarting samba"
systemctl restart smb.service
systemctl restart nmb.service
echo "Adding firewall rule for samba"
firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload
echo "Adding administrator to samba users"
usermod -aG users administrator
echo "Set password for administrator for samba"
smbpasswd -a administrator
fi

read -p "Install and configure Webmin? [yn]" answer
if [[ $answer = y ]] ; then
  wget http://www.webmin.com/download/rpm/webmin-current.rpm
  rpm -U webmin-current.rpm
echo "Webmin installed, please synchronise Samba users and system user in servers, samba windows file sharing, user sync, and select yes to everything and apply"
echo "Create new users in Samba, Users and groups and put them in users group"
fi

read -p "Configure iptables firewall? [yn]" answer
if [[ $answer = y ]] ; then
  read -p "Turn off firewall? [yn]" answer
  if [[ $answer = y ]] ; then
    systemctl stop firewalld.service
  fi
echo "iptables configured"
echo "Use the command iptables -A INPUT -p tcp --dport PORT -j ACCEPT to add more later"
fi

read -p "Install a Dynamic MOTD? [yn]" answer
if [[ $answer = y ]] ; then
  mkdir setupfiles
  cd serverfiles
  wget http://giz.moe/server-scripts/dynmotd/centos-7/dynmotd
  wget http://giz.moe/server-scripts/dynmotd/login
  wget http://giz.moe/server-scripts/dynmotd/profile
  wget http://giz.moe/server-scripts/dynmotd/sshd_config
  wget http://giz.moe/server-scripts/dynmotd/screenfetch
  cp dynmotd /usr/local/bin/
  cp login /etc/pam.d/
  cp profile /etc/
  cp sshd_config /etc/ssh/
  cp sshd_config /etc/ssh/
  mv screenfetch /usr/bin/
  chown root /etc/pam.d/login
  chown root /etc/profile
  chown root /etc/ssh/
  chmod 755 /usr/local/bin/dynmotd
  chmod 644 /etc/pam.d/login
  chmod 644 /etc/profile
  chmod 600 /etc/ssh/sshd_config
  chmod 755 /usr/bin/screenfetch
  systemctl restart sshd
echo "Edit /usr/local/bin/dynmotd to change the MOTD."
echo "Log out and log back in to test the new MOTD"
fi