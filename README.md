# Introduction
This is an image file repository for testing QEMU.

The default root file system is built with [linaro gcc 4.9](https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz).
Please download this compiler and add to PATH if you want to compile your own binary.

# 3 Steps to Use
1. Make sure the __snippits/qemu_vpmu__ is built.
2. Run `./download.sh` to download pre-built images.
3. Execute `./runQEMU.sh vexpress`. That's it!!

# Prepare Images
We've prepared a pre-built image to start. Please download it by running `./download.sh`.
After downloading the files, they would be automatically decompressed and ready for use.
The pre-built image will automatically mount the attached custom disk image to `/root` if __-drive__ option presents.

To make changes of the images, one can use `snippit image push <FILE PATH> to <IMAGE NAME>`.
To get the list of installed images, one can use `snippit image list`.

The following is manual method to push/pull custom files/binaries into/from the image.
## ARM Images
1. Create your ext3 image for mounting at `/root` in the guest OS, and then copy all the files in original `/root` into new `/root`.
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
sudo cp -r ./rootfs/root/* ./tmpfs
sudo cp ./rootfs/root/.bash_profile ./tmpfs
sudo cp ./rootfs/root/.bashrc ./tmpfs
sync
sync
sync
sudo umount ./tmpfs
rmdir tmpfs
```
2. Run your image with __-drive__ option when executing the script. `./runQEMU.sh -drive ./data.ext3` Our pre-built image will mount the new disk to `/root` if __-drive__ option presents. There is no need to modify the image.

## Arch Linux Image (ARM)
1. Run `runme.sh` in __arch_arm__ folder
2. Run `./runQEMU.sh arm_arch`
3. In guest system, run `insmod ./vpmu-device-arm.ko`.
4. You can now run `./profile.sh --phase ls -al` in guest system.

## Custom Image
If you want to profile with your own image, remember to take a look at the script `./runQEMU.sh` for input argument template.
Also, event tracing and phase detection require kernel headers or source to compile device driver.
Please follow the instruction in the __snippits/vpmu_control__ repo.

If you need instructions on building your own image. Please follow the blog [post](https://medicineyeh.wordpress.com/2016/03/29/buildup-your-arm-image-for-qemu/).

Besides image, you also need to build the device driver and controller in __snippits/vpmu_controller__.
Then put __vpmu-device-<ARCH>.ko__ and __vpmu-control-<ARCH>__ into your image, where ARCH could be either x86 or arm.

# Networking
1. Prepare bridge network as listed on [Arch Wiki](https://wiki.archlinux.org/index.php/QEMU#Creating_bridge_manually)
2. Run script with __-net__ option. `./runQEMU.sh -net`

# Change Configuration of Emulation
The configuration file is __default.json__ for ARM and __default_x86.json__ for x86_64.

# Usage
## Run emulation with script
* Simple execution `./runQEMU.sh vexpress`
* Debug with gdb `./runQEMU.sh vexpress -g`
* Attach a new disk image `./runQEMU.sh vexpress -drive <PATH>`
* Redirect the output path of phase and logs `./runQEMU.sh -o <PATH> vexpress`
* Please refer to `./runQEMU.sh -h` for more options

## Change window size
Sometime the windows size (granularity) would affect the results and make it hard to read.
Adjusting the window size is a way to inspect your code. Future version would be able to
adjust window size offline. The current version can only do this when running program.
Window size is assigned by environment variable in the unit of kilo instructions.
Ex:
* 200k instructions (default size) `PHASE_WINDOW_SIZE=200 ./runQEMU.sh vexpress`
* 500k instructions `PHASE_WINDOW_SIZE=500 ./runQEMU.sh vexpress`


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

