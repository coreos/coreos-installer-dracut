#!/bin/bash

install_and_enable_unit() {
    unit="$1"; shift
    target="$1"; shift
    inst_simple "$moddir/$unit" "$systemdsystemunitdir/$unit"
    # note we `|| exit 1` here so we error out if e.g. the units are missing
    # see https://github.com/coreos/fedora-coreos-config/issues/799
    systemctl -q --root="$initdir" add-requires "$target" "$unit" || exit 1
}

depends() {
    echo clevis clevis-pin-null
}

install() {

    inst_multiple \
    coreos-installer \
    gpg        \
    gpg-agent  \
    realpath   \
    basename   \
    blkid      \
    cat        \
    dirname    \
    findmnt    \
    growpart   \
    realpath   \
    resize2fs  \
    tail       \
    tune2fs    \
    touch      \
    xfs_admin  \
    xfs_growfs \
    wc         \
    lsblk      \
    wipefs     \
    awk        \
    cat        \
    dd         \
    grep       \
    mktemp     \
    partx      \
    rm         \
    sed        \
    sfdisk     \
    sgdisk     \
    find       \
    gpg-connect-agent \
    clevis-luks-unlock

    inst_simple "$moddir/coreos-installer-generator" \
        "$systemdutildir/system-generators/coreos-installer-generator"

    inst_script "$moddir/coreos-installer-service" \
        "/usr/libexec/coreos-installer-service"

    install_and_enable_unit "coreos-installer.service" \
        "default.target"

    install_and_enable_unit "coreos-installer-reboot.service" \
        "default.target"

    install_and_enable_unit "coreos-installer-noreboot.service" \
        "default.target"

    install_and_enable_unit "coreos-installer-poweroff.service" \
        "default.target"

    install_and_enable_unit "coreos-installer-growfs.service" \
        "default.target"

    inst_script "$moddir/coreos-installer-growfs" \
        /usr/libexec/coreos-installer-growfs

    inst_simple "$moddir/coreos-installer.target" \
        "${systemdsystemunitdir}/coreos-installer.target"

    inst_simple "$moddir/coreos-installer-luks-open.service" \
        "${systemdsystemunitdir}/coreos-installer-luks-open.service"
}
