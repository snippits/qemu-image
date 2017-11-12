# This will be the location of settings.sh
export SCRIPT_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
export IMAGE_DIR="${SCRIPT_DIR}/guest-images"
# The name of ROOTFS_DIR must be rootfs for safety.
export ROOTFS_DIR="$(readlink -f "${IMAGE_DIR}/rootfs")"
export RUN_QEMU_SCRIPT_PATH="${SCRIPT_DIR}"
