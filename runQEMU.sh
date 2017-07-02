#!/bin/bash
# Copyright (c) 2017, Medicine Yeh

SCRIPT_PATH="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
IMAGE_DIR="$SCRIPT_PATH/images"
#Use PATH to automatically solve the binary path problem.
export PATH=$(pwd)/arm-softmmu/:$SCRIPT_PATH/../qemu_vpmu/build/arm-softmmu/:$PATH
export PATH=$(pwd)/x86_64-softmmu/:$SCRIPT_PATH/../qemu_vpmu/build/x86_64-softmmu/:$PATH
export PATH=$(pwd)/i386-softmmu/:$SCRIPT_PATH/../qemu_vpmu/build/i386-softmmu/:$PATH
QEMU_ARM=qemu-system-arm
QEMU_X86=qemu-system-x86_64
QEMU_ARGS=()
QEMU_EXTRA_ARGS=()

QEMU_ARGS+=(-m 1024)
QEMU_ARGS+=(--nographic)
# QEMU_ARGS+=(-vpmu-kernel-symbol $IMAGE_DIR/vmlinux)
# QEMU_ARGS+=(-drive if=sd,driver=raw,cache=writeback,file=$IMAGE_DIR/data.ext3)

function print_help() {
    echo "Usage:"
    echo "       $0 [OPTION]... <DEVICE NAME>"
    echo "  Execute QEMU with preset arguments for execution."
    echo ""
    echo "Options:"
    echo "       -net                : Enable networks"
    echo "       -g                  : Use gdb to run QEMU"
    echo "       -gg                 : Run QEMU with remote gdb mode to debug guest program"
    echo "                             Default port: 1234"
    echo "       -o <OUTPUT PATH>    : Specify the output directory for emulation"
    echo "                             OUTPUT PATH is the path to a directory for logs and files."
    echo "                             default: /tmp/snippit"
    echo ""
    echo "Options to QEMU:"
    echo "       -smp <N>            : Number of cores (default: 1)"
    echo "       -m <N>              : Size of memory (default: 1024)"
    echo "       -snapshot           : Read only guest image"
    echo "       -enable-kvm         : Enable KVM"
    echo "       -drive <PATH>       : Hook another disk image to guest"
    echo ""
    echo "Device Name List:"
    echo "       x86_busybox"
    echo "       x86_arch"
    echo "       arm_arch"
    echo "       vexpress"
}

function open_tap() {
    if [[ $(sudo -n ip 2>&1|grep "Usage"|wc -l) == 0 ]] \
        || [[ $(sudo -n brctl 2>&1|grep "Usage"|wc -l) == 0 ]]; then
        echo -e "\033[1;37m#You can add the following line into sudoer to save your time\033[0;00m"
        echo -e "\033[1;32m$(whoami) ALL=NOPASSWD: /usr/bin/ip, /usr/bin/brctl\033[0;00m"
    fi
    sudo ip tuntap add tap0 mode tap user $(whoami)
}

function link_vmlinux() {
    cd "$IMAGE_DIR"
    ln -sf "$(pwd)/$1" "./vmlinux"
    cd -
}

function generate_random_mac_addr() {
    if [ ! -f $SCRIPT_PATH/.macaddr ]; then
        printf -v macaddr \
            "52:54:%02x:%02x:%02x:%02x" \
            $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))
        echo $macaddr > $SCRIPT_PATH/.macaddr
    fi
    MAC_ADDR=$(cat $SCRIPT_PATH/.macaddr)
}

while [[ "$1" != "" ]]; do
    # Parse arguments
    case "$1" in
        "-net" )
            generate_random_mac_addr
            open_tap
            QEMU_ARGS+=(-net nic,model=virtio,macaddr=$MAC_ADDR -net tap,vlan=0,ifname=tap0)
            shift 1
            ;;
        "-g" )
            # Disable file buffering to get the latest results from output
            # One could also use command 'call fflush({file descriptor})' in gdb
            export LD_PRELOAD=${SCRIPT_PATH}/nobuffering.so
            QEMU_ARM="gdb --args $QEMU_ARM"
            QEMU_X86="gdb --args $QEMU_X86"
            shift 1
            ;;
        "-gg" )
            QEMU_ARGS+=(-S -gdb tcp::1234)
            shift 1
            ;;
        "-o" )
            QEMU_EXTRA_ARGS+=(-vpmu-output "$(readlink -f "$2")")
            shift 2
            ;;
        "-smp" )
            QEMU_ARGS+=(-smp $2)
            shift 2
            ;;
        "-m" )
            QEMU_ARGS+=(-m $2)
            shift 2
            ;;
        "-snapshot" )
            QEMU_ARGS+=(-snapshot)
            shift 1
            ;;
        "-enable-kvm" )
            QEMU_ARGS+=(-enable-kvm)
            shift 1
            ;;
        "-drive" )
            QEMU_ARGS+=(-drive if=sd,driver=raw,cache=writeback,file=$2)
            shift 2
            ;;
        "-h" )
            print_help
            exit 0
            ;;
        "--help" )
            print_help
            exit 0
            ;;
        * )
            dev="$1"
            shift 1
            ;;
    esac
done

if [ -z "$dev" ]; then
    # No device name after options
    print_help
    exit 1
fi

case "$dev" in
    "x86_arch" )
        QEMU=$QEMU_X86
        QEMU_ARGS+=(-M pc)
        QEMU_ARGS+=(-boot order=c)
        QEMU_ARGS+=(-cdrom "$IMAGE_DIR/x86_64/archlinux.iso")
        QEMU_ARGS+=(-drive file="$IMAGE_DIR/x86_64/paslab.ext4",format=raw)
        QEMU_ARGS+=(-vpmu-config "$SCRIPT_PATH/default_x86.json")
        ;;
    "x86_busybox" )
        QEMU=$QEMU_X86
        QEMU_ARGS+=(-M pc)
        QEMU_ARGS+=(-kernel "$IMAGE_DIR/x86_busybox/bzImage")
        QEMU_ARGS+=(-drive file="$IMAGE_DIR/x86_busybox/rootfs_x86.ext2",format=raw)
        QEMU_ARGS+=(-append "root=/dev/sda console=ttyS0")
        QEMU_ARGS+=(-vpmu-config "$SCRIPT_PATH/default_x86.json")
        ;;
    "arm_arch" )
        link_vmlinux "./arch_arm/vmlinux_arch"
        QEMU=$QEMU_ARM
        QEMU_ARGS+=(-M vexpress-a9)
        QEMU_ARGS+=(-kernel "$IMAGE_DIR/arch_arm/zImage_arch")
        QEMU_ARGS+=(-dtb "$IMAGE_DIR/arch_arm/vexpress-v2p-ca9.dtb")
        QEMU_ARGS+=(-drive if=sd,driver=raw,cache=writeback,file="$IMAGE_DIR/arch_arm/paslab.ext4")
        QEMU_ARGS+=(-append "root=/dev/mmcblk0 rw roottype=ext4 console=ttyAMA0")
        QEMU_ARGS+=(-vpmu-config "$SCRIPT_PATH/default.json")
        ;;
    "vexpress" )
        link_vmlinux "./kernels/vmlinux_vexpress"
        QEMU=$QEMU_ARM
        QEMU_ARGS+=(-M vexpress-a9)
        QEMU_ARGS+=(-kernel "$IMAGE_DIR/kernels/zImage_vexpress")
        QEMU_ARGS+=(-dtb "$IMAGE_DIR/vexpress-v2p-ca9.dtb")
        QEMU_ARGS+=(-initrd "$IMAGE_DIR/rootfs.cpio")
        QEMU_ARGS+=(-append "console=ttyAMA0")
        QEMU_ARGS+=(-vpmu-config "$SCRIPT_PATH/default.json")
        ;;
    * )
        echo "Device \"$dev\" is not in the list"
        exit 1
        ;;
esac

# echo "Running command: ${QEMU} ${QEMU_ARGS[*]} ${QEMU_EXTRA_ARGS[*]}"
# Execute QEMU
$QEMU "${QEMU_ARGS[@]}" "${QEMU_EXTRA_ARGS[@]}"

#Leave some time to clean up the forked processes
sleep 0.2
remaining_sims=$(ps -a | grep "cache-simulator" | wc -l)
if [ "$remaining_sims" != 0 ]; then
    echo "Cleaning remaining vpmu sims and reset terminal"
    sleep 1
    killall -9 cache-simulator
    #This would reset the terminal input echo policy
    reset
    echo "Terminal Rest"
fi

