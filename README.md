# Introduction
This is an image file repository for testing QEMU.
Please upgrade the scripts and files before use by `./upgrade.sh`.

The default root file system is built with [linaro gcc 4.8](https://releases.linaro.org/14.11/components/toolchain/binaries/arm-linux-gnueabi/gcc-linaro-4.9-2014.11-x86_64_arm-linux-gnueabi.tar.xz).
Please download this compiler and add to PATH if you want to compile your own binary.

# Prepare Images
We've prepared a pre-built image to start. Please download it with the following steps.
## ARM Images
1. `wget http://pas.csie.ntu.edu.tw/shared/qemu_images.tar`
2. `tar -xf ./qemu_images.tar`
3. Create your ext3 image for mounting at `/root/` in the guest OS.
This is only required when you want to put big binaries/files inside the image.
Also, the ext3 image provides a way to send program to guest.

``` bash
#Uncompress cpio ramfs image
./extract_cpio.sh
#Default generate 1G, feel free to change the size
dd if=/dev/zero of=/tmp/data.ext3 bs=1K count=$((1 * 1024 * 1024))
# Formating to ext3
mkfs.ext3 /tmp/data.ext3
mv /tmp/data.ext3 ./

mkdir -p tmpfs
sudo mount ./data.ext3 ./tmpfs
sudo cp -r ./rootfs/root ./tmpfs
sudo cp ./rootfs/root/.bash_profile ./tmpfs
sudo cp ./rootfs/root/.bashrc ./tmpfs
sync
sync
sync
sudo umount ./tmpfs
rmdir tmpfs
```

## Arch Linux Image (ARM)
1. `wget http://pas.csie.ntu.edu.tw/shared/arch_arm.tar`
2. `tar -xf ./arch_arm.tar`

## Custom Image
If you want to profile your own image, remember to take a look at the script `./runQEMU.sh` for input argument template.
Also, event tracing and phase detection require kernel headers or source to compile device driver.
Please follow the instruction in the __snippits/vpmu_control__ repo.

If you need instructions on building your own image. Please follow the blog [post](https://medicineyeh.wordpress.com/2016/03/29/buildup-your-arm-image-for-qemu/).

# Networking
1. Prepare bridge network as listed on [Arch Wiki](https://wiki.archlinux.org/index.php/QEMU#Creating_bridge_manually)
2. Uncomment the bash function `open_tap` and two lines started with "-net XXXX"

# Change Configuration of Emulation
The configuration file is __default.json__.

# Usage
## Install shell commands and completion
* `source ./install_command.sh`
This will install `snippit` command and completion to `./runQEMU.sh`
Future scripts and functions will be integrated into snippit command as sub commands.
We suggest using this command for consistency.

## Run emulation with snippit command
* `snippit qemu vexpress`

## Run emulation
* Simple execution `./runQEMU.sh vexpress`
* Debug with gdb `./runQEMU.sh -g vexpress`
* Redirect the output path of phase and logs `./runQEMU.sh -o <PATH> vexpress`

## How to Extract the cpio file
* `./extract_cpio.sh`

## How to Compress the rootfs file system to cpio file
* `./cpioBuild.sh`

# Profiling In Guest OS
* run `./profile <TARGET PROGRAM>` to profile a program
* run `./profile --phase <TARGET PROGRAM>` to profile a program with phase detection
* run `./profile --trace <TARGET PROGRAM>` to profile a program with event tracing and user process tracking
* run `./profile --jit <TARGET PROGRAM>` to profile a program with just-in-time model selection
* run `./profile <TARGET PROGRAM> <ARG1> [ARGS...]` with input arguments to profile a program with VPMU.

# Profiling From Host OS
## Use __expect__ to launch the emulator and execute command
A quotation is required in order to pass the command properly.

* `./do_test.expect <COMMANDS> <REPEATED TIMES>`
* `./do_test.expect "./profile.sh <TARGET PROGRAM> [ARGS...]" 1`

## How to calculate the average execution time

This is an exsample of running `matrix` 4 times and output the average execution time
* `./do_test.expect "./profile.sh ./test_set/matrix" 4 | grep "Emulation time" | awk '{ sum += $4; n++ } END { if (n > 0) print sum / n; }'`

