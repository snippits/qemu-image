#!/bin/bash

if [ -d ./rootfs ] ; then
    if [ -e ./rootfs.cpio ] ; then
        while true; do
            read -p "Are you sure you want to overwrite rootfs directory?" yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi
else
    mkdir rootfs
fi

cd rootfs/
cp ../rootfs.cpio ./
sudo cpio -ivdu < rootfs.cpio 
rm rootfs.cpio 
cd ../

