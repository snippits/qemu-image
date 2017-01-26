#!/bin/bash
SCRIPT_PATH=$(dirname $0)
if [ -f ./setenv.sh ]; then
    SETENV_PATH=./setenv.sh
else
    SETENV_PATH=$SCRIPT_PATH/../qemu_vpmu/build/setenv.sh
fi
#Use PATH to automatically solve the binary path problem.
export PATH=$(pwd)/arm-softmmu/:$SCRIPT_PATH/../qemu_vpmu/build/arm-softmmu/:$PATH
export PATH=$(pwd)/x86_64-softmmu/:$SCRIPT_PATH/../qemu_vpmu/build/x86_64-softmmu/:$PATH
export PATH=$(pwd)/i386-softmmu/:$SCRIPT_PATH/../qemu_vpmu/build/i386-softmmu/:$PATH
QEMU=qemu-system-arm
QEMU_X86=qemu-system-x86_64
QEMU_EXTRA_ARGS=''

source $SETENV_PATH
export VPMU_SET_PATH=${SCRIPT_PATH}/

function print_help() {
    echo "Usage:"
    echo "       $0 [OPTION]... <DEVICE NAME>"
    echo "  Execute QEMU with preset arguments for execution."
    echo ""
    echo "OPTION:"
    echo "       -g                  : Use gdb to run QEMU"
    echo "       -o <OUTPUT PATH>    : Specify the output directory for emulation"
    echo "                             OUTPUT PATH is the path to a directory for logs and files."
    echo "                             default: /tmp/snippit"
    echo ""
    echo "Device Name List:"
    echo "       x86_64"
    echo "       arch"
    echo "       vexpress"
    echo "       versatile"
    echo "       realview"
}

function open_tap() {
    if [ $(sudo -n ip 2>&1|grep "Usage"|wc -l) == 0 ] \
        || [ $(sudo -n brctl 2>&1|grep "Usage"|wc -l) == 0 ]; then
        echo -e "\033[1;37m#You can add the following line into sudoer to save your time\033[0;00m"
        echo -e "\033[1;32m$(whoami) ALL=NOPASSWD: /usr/bin/ip, /usr/bin/brctl\033[0;00m"
    fi
    sudo ip tuntap add tap0 mode tap user $(whoami)
}

function link_vmlinux() {
    cd $SCRIPT_PATH
    #Remove only when it's symbolic link to prevent problems
    [ -f ./vmlinux ] && rm ./vmlinux
    cp "$(pwd)/$1" "./vmlinux"
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

while [[ 1 ]]; do
    # Parse arguments
    case "$1" in
        "-g" )
            # Disable file buffering to get the latest results from output
            # One could also use command 'call fflush({file descriptor})' in gdb
            export LD_PRELOAD=${SCRIPT_PATH}/nobuffering.so
            QEMU="gdb --args $QEMU"
            shift 1
            ;;
        "-o" )
            QEMU_EXTRA_ARGS+=" -vpmu-output '$2'"
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
            break
            ;;
    esac
done

if [ -z "$dev" ]; then
    # No device name after options
    print_help
    exit 1
fi

generate_random_mac_addr
case "$dev" in
    "x86_64" )
        #open_tap
        $QEMU_X86 \
        -boot order=c\
        -cdrom $SCRIPT_PATH/x86_64/archlinux.iso \
        -drive file=$SCRIPT_PATH/x86_64/paslab.ext4,format=raw \
        -m 2048 \
        -smp 4 \
        $QEMU_EXTRA_ARGS \
        --nographic \
        -snapshot \
        #-net nic,model=virtio,macaddr=$MAC_ADDR \
        #-net tap,vlan=0,ifname=tap0 \
        #-enable-kvm \
        ;;
    "arch" )
        link_vmlinux "./arch_arm/vmlinux_arch"
        #open_tap
        $QEMU \
        -M vexpress-a9 \
        -kernel $SCRIPT_PATH/arch_arm/zImage_arch \
        -dtb $SCRIPT_PATH/arch_arm/vexpress-v2p-ca9.dtb \
        -drive if=sd,driver=raw,cache=writeback,file=$SCRIPT_PATH/arch_arm/paslab.ext4 \
        -append "root=/dev/mmcblk0 rw roottype=ext4 console=ttyAMA0" \
        -vpmu-config "$SCRIPT_PATH/default.json" \
        $QEMU_EXTRA_ARGS \
        --nographic \
        -snapshot \
        #-vpmu-kernel-symbol $SCRIPT_PATH/vmlinux \
        #-net nic,macaddr=$MAC_ADDR \
        #-net tap,vlan=0,ifname=tap0
        ;;
    "vexpressold" )
        link_vmlinux "./kernels/vmlinux_vexpress"
        #open_tap
        $QEMU \
        -M vexpress-a9 \
        -kernel $SCRIPT_PATH/kernels/zImage_vexpress \
        -initrd $SCRIPT_PATH/rootfs.cpio  \
        -dtb $SCRIPT_PATH/vexpress-v2p-ca9.dtb \
        -append "console=ttyAMA0" \
        --nographic \
        #-snapshot \
        #-drive if=sd,driver=raw,cache=writeback,file=$SCRIPT_PATH/data.ext3
        #-net nic,macaddr=$MAC_ADDR \
        #-net tap,vlan=0,ifname=tap0 \
        #-drive if=sd,driver=raw,cache=writeback,file=$SCRIPT_PATH/data.ext3
        ;;
    "vexpress" )
        link_vmlinux "./kernels/vmlinux_vexpress"
        #open_tap
        $QEMU \
        -M vexpress-a9 \
        -kernel $SCRIPT_PATH/kernels/zImage_vexpress \
        -initrd $SCRIPT_PATH/rootfs.cpio  \
        -dtb $SCRIPT_PATH/vexpress-v2p-ca9.dtb \
        -append "console=ttyAMA0" \
        -vpmu-config "$SCRIPT_PATH/default.json" \
        $QEMU_EXTRA_ARGS \
        --nographic \
        #-vpmu-kernel-symbol $SCRIPT_PATH/vmlinux \
        #-snapshot \
        #-drive if=sd,driver=raw,cache=writeback,file=$SCRIPT_PATH/data.ext3
        #-net nic,macaddr=$MAC_ADDR \
        #-net tap,vlan=0,ifname=tap0 \
        #-drive if=sd,driver=raw,cache=writeback,file=$SCRIPT_PATH/data.ext3
        ;;
    "versatile" )
        link_vmlinux "./kernels/vmlinux_versatilepb"
        $QEMU \
        -kernel $SCRIPT_PATH/kernels/zImage_versatilepb \
        -initrd $SCRIPT_PATH/rootfs.cpio \
        -append "console=ttyAMA0" \
        -vpmu-config "$SCRIPT_PATH/default.json" \
        $QEMU_EXTRA_ARGS \
        -nographic \
        -M versatilepb
        ;;
    "realview" )
        $QEMU \
        -kernel $SCRIPT_PATH/kernels/zImage_realview_pbx_a9 \
        -initrd $SCRIPT_PATH/rootfs.cpio \
        -append "console=ttyAMA0" \
        -vpmu-config "$SCRIPT_PATH/default.json" \
        $QEMU_EXTRA_ARGS \
        -nographic \
        -M realview-pbx-a9 \
        -m 1024M
        ;;
    * )
        echo "Device \"$dev\" is not in the list"
        exit 1
        ;;
esac

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

