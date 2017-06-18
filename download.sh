#!/bin/bash

[[ ! -f qemu_images-v2.tar ]] && wget http://pas.csie.ntu.edu.tw/shared/qemu_images-v2.tar
tar -xf ./qemu_images-v2.tar
./extract_cpio.sh

[[ ! -f arch_arm.tar ]] && wget http://pas.csie.ntu.edu.tw/shared/arch_arm.tar
tar -xf ./arch_arm.tar

