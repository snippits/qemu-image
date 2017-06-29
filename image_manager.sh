#!/bin/bash
SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")
all_file_list=$(find ${SCRIPT_PATH} -path ${SCRIPT_PATH}/rootfs -prune -o -exec file {} \;)

function get_list() {
    local l_list=$(echo "$all_file_list" | grep -e "$1")
    [[ "$l_list" ]] && l_list=$(echo "$l_list" | cut -d ":" -f 1)
    echo "$l_list"
}

cpio_list=$(get_list "ASCII cpio archive")
e2fs_list=$(get_list "Linux .* ext.* filesystem data")
mbr_list=$(get_list "MBR boot sector")

# Input: File name or full path
# Output: The image file path found in the list
function find_image_file_in_list() {
    local tmp=''
    local img_name="$1"

    # Convert the results into array type and check if the first match exist
    tmp=($(echo "${cpio_list}" | grep "${img_name}"))
    [[ "${tmp[0]}" != "" ]] && echo "${tmp[0]}" && return 0

    tmp=($(echo "${e2fs_list}" | grep "${img_name}"))
    [[ "${tmp[0]}" != "" ]] && echo "${tmp[0]}" && return 0

    tmp=($(echo "${mbr_list}" | grep "${img_name}"))
    [[ "${tmp[0]}" != "" ]] && echo "${tmp[0]}" && return 0

    echo "" && return 4
}

function pretty_print_list() {
    local list="${1}"

    for f in ${list}; do
        printf "%-40s  %-20s  %-20s\n" "${f##./}" $(get_image_type "${f}") $(du -h "${f}" | cut -f1)
    done
}

function list_images() {
    printf "%-40s  %-20s  %-20s\n" 'IMAGE NAME' 'TYPE' 'SIZE'
    pretty_print_list "$cpio_list"
    pretty_print_list "$e2fs_list"
    pretty_print_list "$mbr_list"

    echo "" # Empty line
}

# Input: file path
# Output: (Capitalized) ext version string
function get_ext_version() {
    local ff=$(file "$1")
    local type=$(expr "$ff" : '^.*\(ext[0-9]\)')
    echo "${type}" | tr '[:lower:]' '[:upper:]'
}

# Output: "": not found. Others: Types of image
function get_image_type() {
    local tmp=''

    tmp=$(echo "${cpio_list}" | grep "$1")
    [[ "$tmp" != "" ]] && echo "CPIO" && return 0

    tmp=$(echo "${e2fs_list}" | grep "$1")
    [[ "$tmp" != "" ]] && echo $(get_ext_version "$1") && return 0

    tmp=$(echo "${mbr_list}" | grep "$1")
    [[ "$tmp" != "" ]] && echo "MBR" && return 0

    echo "" && return 4
}

function extract_cpio() {
    local file_path=$(readlink -f "$1")
    [[ ! -r "$file_path" ]] && exit 4
    mkdir -p ${SCRIPT_PATH}/rootfs
    cd ${SCRIPT_PATH}/rootfs/
    echo "Extracting CPIO image..."
    sudo cpio -idu < $file_path
    cd - > /dev/null # Mute the folder change message
}

function build_cpio() {
    local file_path=$(readlink -f "$1")
    [[ ! -r "$file_path" ]] && exit 4
    cd ${SCRIPT_PATH}/rootfs
    echo "Compressing CPIO image..."
    sudo find . | sudo cpio -H newc -o > $file_path
    cd - > /dev/null # Mute the folder change message
}

function concatenate_path() {
    local path1="${1%%/}"
    local path2="${2%%/}"
    local out_path="$path1/${path2##/}"
    echo "${out_path}"
}

function copy_file() {
    # Remove the tailing slash
    local from_file="${1%%/}"
    local to_file="${2%%/}"
    local to_dir="$(dirname "$to_file")"

    [[ ! -f "$from_file" ]] && echo "File path '$from_file' does not exist" && exit 4
    [[ ! -d "$to_file" ]] && [[ ! -d "$to_dir" ]] && echo "File path '$to_file' does not exist" && exit 4
    if [[ -r "$from_file" ]] && [[ -w "$to_file" ]]; then
        # Permission is granted to the current user
        cp "$from_file" "$to_file"
    else
        # Use privilege permission
        sudo cp "$from_file" "$to_file"
    fi
}

# Input 1: file, 2: <image>@<file path>
function push_file_to_image() {
    local RED='\033[1;31m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'
    local file_path="$1"
    local tmp_img_name="${2%%@*}"
    local image_path=$(find_image_file_in_list ${tmp_img_name})
    local to_file_path="${2##*@}"
    local type=$(get_image_type "$image_path")

    # Number of input arguments
    if [[ ${#*} != 2 ]]; then
        echo "Please follow the input argument format: <file> <image name>@<file path>"
        exit 4
    fi
    echo "Copy file '${file_path}' into image '${image_path}' with path '${to_file_path}'"
    echo ""

    if [[ ! -r $file_path ]]; then
        echo -e "${RED}[Fatal] File ${file_path} was not found or cannot be read${NC}"
        exit 4
    fi
    if [[ "$image_path" == "" ]]; then
        echo -e "${RED}[Fatal] Image ${tmp_img_name} was not found${NC}"
        echo "Please specify one of the following:"
        list_images
        exit 4
    fi
    if [[ "$to_file_path" == "" ]]; then
        echo -e "${RED}[Fatal] File path in target image filesystem cannot be empty${NC}"
        exit 4
    fi
    if [[ "${to_file_path:0:1}" == "~" ]]; then
        echo -e "${RED}[Fatal] File path in target image filesystem cannot start with ~/${NC}"
        exit 4
    fi

    case "$type" in
    "") echo "Not Found" ;;
    "CPIO")
        echo "Extracting cpio image, it requires root privilege to create rootfs"
        sudo echo -e "${YELLOW}Running with root privilege now...${NC}"
        [[ $? != 0 ]] && echo -e "${RED}Abort${NC}" && exit 4
        extract_cpio $image_path
        copy_file "$file_path" $(concatenate_path "${SCRIPT_PATH}/rootfs/" "$to_file_path")
        build_cpio $image_path
        ;;
    "EXT2" | "EXT3" | "EXT4")
        echo "Mounting e2fs image (raw), it requires root privilege to mount"
        sudo echo -e "${YELLOW}Running with root privilege now...${NC}"
        [[ $? != 0 ]] && echo -e "${RED}Abort${NC}" && exit 4
        sudo mount $image_path ${SCRIPT_PATH}/rootfs
        copy_file "$file_path" $(concatenate_path "${SCRIPT_PATH}/rootfs/" "$to_file_path")
        sudo umount ${SCRIPT_PATH}/rootfs
        ;;
    "MBR")
        echo "Mounting disk image (partitioned), it requires root privilege to mount"
        echo "Not implemented"
        return 4
        sudo echo -e "${YELLOW}Running with root privilege now...${NC}"
        [[ $? != 0 ]] && echo -e "${RED}Abort${NC}" && exit 4
        ;;
    *) echo "[Fatal] undefined condition" ;;
    esac
}


