#!/bin/bash

cd rootfs/
cp ../rootfs.cpio ./
sudo cpio -ivdu < rootfs.cpio 
rm rootfs.cpio 
cd ../

