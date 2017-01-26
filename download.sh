#!/bin/bash

[[ ! -f qemu_images.tar ]] && wget http://pas.csie.ntu.edu.tw/shared/qemu_images.tar
tar -xf ./qemu_images.tar
./extract_cpio.sh

[[ ! -f arch_arm.tar ]] && wget http://pas.csie.ntu.edu.tw/shared/arch_arm.tar
tar -xf ./arch_arm.tar

