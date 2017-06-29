#!/bin/bash
SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")
files=('qemu_images-v2.tar'
       'arch_arm.tar')

links=('http://pas.csie.ntu.edu.tw/shared/qemu_images-v2.tar'
       'http://pas.csie.ntu.edu.tw/shared/arch_arm.tar')

sha256sums=('68ef08ef3ee3aa47bd7e1af1080f9d77a026f7b7127fb642a3fc3fad13bffcca'
            '033a8ca7803513a47c22d05d0fae0006fd3641211a4ffc9a6c620734d94920ac')

function check_sha256() {
    local sum=$(sha256sum -b $1 | cut -d " " -f1)
    [[ "$sum" == "$2" ]] && return 0 # true
    return 1 # false
}

function unfold_file() {
    local filename=$(basename "$1")
    local extension="${filename##*.}"
    local GREEN='\033[1;32m'
    local BLUE='\033[1;34m'
    local NC='\033[0m'

    case "$extension" in
        "tar" )
            echo -e "${GREEN}decompress file $file_path${NC}"
            tar -xf $1
            ;;
        * )
            echo -e "${BLUE}passed${NC}"
            ;;
    esac
}

function main() {
    local RED='\033[1;31m'
    local NC='\033[0m'
    local index=0

    cd ${SCRIPT_PATH}
    for file_path in "${files[@]}"; do
        [[ ! -f ${file_path} ]] && wget ${links[${index}]}
        if $(check_sha256 $file_path ${sha256sums[${index}]}); then
            unfold_file $file_path
        else
            echo -e "${RED}Fatal: The file '$file_path' sha256sum does not match!!${NC}"
        fi
        index+=1
    done
}

main

