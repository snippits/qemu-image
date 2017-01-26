#!/bin/bash

wget http://pas.csie.ntu.edu.tw/shared/qemu_images.tar
tar -xf ./qemu_images.tar
./extract_cpio.sh

wget http://pas.csie.ntu.edu.tw/shared/arch_arm.tar
tar -xf ./arch_arm.tar

