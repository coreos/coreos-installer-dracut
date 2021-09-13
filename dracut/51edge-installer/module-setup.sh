#!/bin/bash

install_and_enable_unit() {
    unit="$1"; shift
    target="$1"; shift
    inst_simple "$moddir/$unit" "$systemdsystemunitdir/$unit"
    # note we `|| exit 1` here so we error out if e.g. the units are missing
    # see https://github.com/coreos/fedora-coreos-config/issues/799
    systemctl -q --root="$initdir" add-requires "$target" "$unit" || exit 1
}

install() {
    inst_multiple gpg
    inst_multiple gpg-agent
    inst_multiple gpg-connect-agent
    inst_multiple coreos-installer

    inst_multiple \
    realpath \
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
    wipefs

    inst_multiple \
        awk       \
        cat       \
        dd        \
        grep      \
        mktemp    \
        partx     \
        rm        \
        sed       \
        sfdisk    \
        sgdisk    \
        find
        
    inst_multiple -o \
        clevis-encrypt-sss \
        clevis-encrypt-tang \
        clevis-encrypt-tpm2 \
        clevis-luks-bind \
        clevis-luks-common-functions \
        clevis-luks-unlock \
        pwmake \
        tpm2_create

    inst_simple "$moddir/edge-installer-generator" \
        "$systemdutildir/system-generators/edge-installer-generator"

    inst_script "$moddir/edge-installer-service" \
        "/usr/libexec/edge-installer-service"

    install_and_enable_unit "edge-installer.service" \
        "default.target" 

    install_and_enable_unit "edge-installer-reboot.service" \
        "default.target" 

    install_and_enable_unit "growfs.service" \
        "default.target"

    inst_script "$moddir/growfs" \
        /usr/sbin/growfs
}
