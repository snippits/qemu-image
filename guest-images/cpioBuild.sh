#!/bin/bash

#if [ -d ./rootfs ] ; then
#    if [ -e ./rootfs.cpio ] ; then
#        while true; do
#            read -p "Are you sure you want to overwrite rootfs.cpio?" yn
#            case $yn in
#                [Yy]* ) break;;
#                [Nn]* ) exit;;
#                * ) echo "Please answer yes or no.";;
#            esac
#        done
#    fi
#else
#    echo "You don't have a rootfs directory."
#    exit;
#fi


cd rootfs
sudo find . | sudo cpio -H newc -o > ../rootfs.cpio
cd ../
echo "FINISH"


