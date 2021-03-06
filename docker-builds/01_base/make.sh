#!/bin/bash
dpkg_arch=$(dpkg-architecture -qDEB_HOST_ARCH)
debian_release="testing"
docker_root="./docker-root"
old_pwd="$PWD"
image_name="lilwharfie"


if [ "$USER" == "root" ]; then
    rm -rf "$docker_root" root.tar*
    mkdir -p $docker_root
    debootstrap \
    --variant=minbase                                   \
    --components=main,contrib,non-free                  \
    --include=locales,apt,apt-utils,aptitude,unattended-upgrades,procps,lsof,net-tools,iputils-ping,traceroute,iproute2,less,man-db,manpages,dialog,bash-completion,cron  \
    --exclude=init,systemd,systemd-sysv,udev,dmsetup    \
    --no-check-gpg                                      \
    --arch=$dpkg_arch                                   \
    $debian_release $docker_root http://httpredir.debian.org/debian &&
    cd "$docker_root" &&
    tar -cf "../root.tar" . &&
    docker import "../root.tar" ${image_name}_root:${dpkg_arch} &&
    rm -vf "../root.tar" &&
    cd "$old_pwd" &&
    docker build -f Dockerfile -t ${image_name}_base:${dpkg_arch} . 
    rm -rf "$docker_root"    
else
    echo "You must be root to build the base environment for this Docker image"
    exit 1
fi;
