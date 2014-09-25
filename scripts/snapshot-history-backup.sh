#! /bin/bash
#if [[ $UID -ne 0 ]]; then sudo "$0"; exit 0; fi
cp -a /[$Directory Source/[$Source name] /[$DIRECTORY Target]/[$Source Name]/snapshot.$(date +%Y-%m-%d)
find /[$DIRECTORY Target]/[$Source Name] -type d -ctime +9 -exec rm -rf {} \;
echo "[$Server Name] has performed the scheduled backup." | mail -s [$Put Name Here] Server Backup [$Your Email Address]

#EXAMPLE
#cp -a /mnt/raid /media/usb_hdd/backups/raid/snapshot.$(date +%Y-%m-%d)
#find /media/usb_hdd/backups/raid -type d -ctime +9 -exec rm -rf {} \;
#echo "Jeeves has performed the scheduled backup." | mail -s Jeeves Server Backup nobody@example.com
