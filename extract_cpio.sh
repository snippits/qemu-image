#!/bin/bash

mkdir -p rootfs
cd rootfs/
cp ../rootfs.cpio ./
echo "Extracting cpio image, it requires root privilege to create rootfs"
sudo cpio -ivdu < rootfs.cpio
rm rootfs.cpio 
cd ../

