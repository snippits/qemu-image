#!/bin/bash
SCRIPT_PATH="$(dirname "${BASH_SOURCE[0]}")"
IMAGE_DIR="$SCRIPT_PATH/images"

files=('qemu_images-v2.tar'
       'arch_arm.tar')

links=('http://pas.csie.ntu.edu.tw/shared/qemu_images-v2.tar'
       'http://pas.csie.ntu.edu.tw/shared/arch_arm.tar')

sha256sums=('baedfced2cd73de0270239e002df5d581a02ac32e6db836f88d3e32392b36ed5'
            '033a8ca7803513a47c22d05d0fae0006fd3641211a4ffc9a6c620734d94920ac')

function check_sha256() {
    local sum=$(sha256sum -b $1 | cut -d " " -f1)
    [[ "$sum" == "$2" ]] && return 0 # true
    return 1 # false
}

function unfold_file() {
    local filename=$(basename "$1")
    local dirname="${filename%%.*}"
    local extension="${filename##*.}"
    local GREEN='\033[1;32m'
    local BLUE='\033[1;34m'
    local NC='\033[0m'

    echo -e "${GREEN}decompress file $file_path${NC}"
    case "$filename" in
        *.tar.gz|*.tgz) tar zxf "$1" ;;
        *.tar.bz2|*.tbz|*.tbz2) tar xjf "$1" ;;
        *.tar.xz|*.txz) tar --xz --help &> /dev/null && tar --xz -xf "$1" || xzcat "$1" | tar xf - ;;
        *.tar.zma|*.tlz) tar --lzma --help &> /dev/null && tar --lzma -xf "$1" || lzcat "$1" | tar xf - ;;
        *.tar) tar xf "$1" ;;
        *.gz) gunzip "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.xz) unxz "$1" ;;
        *.lzma) unlzma "$1" ;;
        *.Z) uncompress "$1" ;;
        *.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk) unzip "$1" -d $dirname ;;
        *.rar) unrar x -ad "$1" ;;
        *.7z) 7za x "$1" ;;
        * ) echo -e "${BLUE}fail to decompress file $file_path${NC}" ;;
    esac
}

function main() {
    local RED='\033[1;31m'
    local NC='\033[0m'
    local index=0

    cd "$IMAGE_DIR"
    for file_path in "${files[@]}"; do
        [[ ! -f ${file_path} ]] && wget ${links[${index}]}
        if $(check_sha256 $file_path ${sha256sums[${index}]}); then
            unfold_file $file_path
        else
            echo -e "${RED}Fatal: The file '$file_path' sha256sum does not match!!${NC}"
        fi
        index+=1
    done
    cd - > /dev/null # Mute the folder change message
}

main

