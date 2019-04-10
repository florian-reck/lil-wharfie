#!/bin/bash -e
#export http_proxy="http://proxy:3142/"
export targetpath="$PWD/root"

create_mounts() {
    mount -o bind /dev "$targetpath/dev" &&
    mount -o bind /dev/pts "$targetpath/dev/pts" &&
    mount -t sysfs /sys "$targetpath/sys" &&
    mount -t proc /proc "$targetpath/proc" 
}

stop_mounts() {
    umount "$targetpath/proc" &&
    umount "$targetpath/sys" &&
    umount "$targetpath/dev/pts" &&
    umount "$targetpath/dev" 
}


rm -rf "$targetpath"
mkdir -p "$targetpath"
debootstrap \
    --variant=minbase                                   \
    --components=main,contrib,non-free                  \
    --include=locales,apt,apt-utils,aptitude,unattended-upgrades,zsh,vim,procps,lsof,net-tools,iputils-ping,traceroute,busybox-syslogd,iptables,iproute2,less,man-db,manpages,dialog,bash-completion,cron,busybox-syslogd  \
    --exclude=init,systemd,systemd-sysv,udev,dmsetup    \
    --no-check-gpg                                      \
    --arch=armhf                                        \
    testing "$PWD/root" http://httpredir.debian.org/debian                  &&
chroot "$targetpath" /usr/bin/passwd --delete root                          &&
chroot "$targetpath" /bin/bash -c 'echo "
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8" >>/etc/profile.d/utf-8.sh
localedef -i en_US -f UTF-8 en_US.UTF-8'                                    &&
chroot "$targetpath" chmod 755 "/etc/profile.d/utf-8.sh"                    &&
chroot "$targetpath" /bin/bash -c 'echo "source /etc/profile" >>/etc/zsh/zshenv ' &&
chroot "$targetpath" /usr/bin/apt-get clean                                 &&
chroot "$targetpath" /usr/bin/apt-get -yq --force-yes purge init systemd systemd-sysv dmsetup <<< 'Yes, do as I say!' &&
chroot "$targetpath" /bin/bash -c 'grep -Pqe "^\s*en_US.UTF-8" /etc/locale.gen || echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen' &&
chroot "$targetpath" /usr/sbin/locale-gen                                   &&
chroot "$targetpath" localedef -i en_US -f UTF-8 en_US.UTF-8                &&
chroot "$targetpath" /usr/bin/chsh -s /usr/bin/zsh root                     &&
chroot "$targetpath" /bin/bash -c 'echo "APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::Unattended-Upgrade \"1\";
APT::Periodic::AutocleanInterval \"14\";
">/etc/apt/apt.conf.d/10periodic' &&
chroot "$targetpath" /bin/bash -c 'echo "Dpkg::Options {
   \"--force-confold\";
} ">/etc/apt/apt.conf.d/local' &&
chroot "$targetpath" /bin/bash -c 'echo "
deb http://ftp.de.debian.org/debian/ buster main non-free contrib
deb-src http://ftp.de.debian.org/debian/ buster main non-free contrib
deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free
deb http://ftp.de.debian.org/debian/ buster-updates main contrib non-free
deb-src http://ftp.de.debian.org/debian/ buster-updates main contrib non-free

deb http://ftp.de.debian.org/debian/ stretch main non-free contrib
deb-src http://ftp.de.debian.org/debian/ stretch main non-free contrib
deb http://security.debian.org/debian-security stretch/updates main contrib non-free
deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free

">/etc/apt/sources.list' &&
chroot "$targetpath" /usr/bin/apt-get update                                &&
create_mounts &&
chroot "$targetpath" /usr/bin/apt-get -yq upgrade                           &&
chroot "$targetpath" /usr/bin/apt-get -yq install openssh-client libpam-radius-auth libpam-cap libpam-sshauth pamtester build-essential cvs git &&
chroot "$targetpath" /usr/bin/apt-get clean                                 &&
chroot "$targetpath" /bin/rm -fv /etc/cron.*/*apt*                          &&
chroot "$targetpath" /bin/ln -fs /usr/lib/apt/apt.systemd.daily /etc/cron.daily  &&
unset http_proxy                                                            &&
wget -O "/tmp/zshrc" "http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc"    && 
cp -v "/tmp/zshrc"      "$targetpath/etc/zsh/zshrc"                         &&
cp -v "/etc/vim/vimrc"  "$targetpath/etc/vim/vimrc"                         &&
echo 'Acquire::http::Proxy "http://bugs.home.floatblog.de:3142/";' > "$targetpath/etc/apt/apt.conf.d/02proxy" &&
echo '#!/bin/bash
source /etc/profile
/etc/init.d/cron start 

if [ -d /etc/docker-init.d ]; then
    for i in /etc/docker-init.d/*.sh; do
        if [ -r "$i" ]; then
          source "$i"
        fi;
    done;
fi;

while true; do sleep 30; done;' >> "$targetpath/etc/docker-init" &&
chroot "$targetpath" chmod 755 "/etc/docker-init" &&
stop_mounts &&
cd "$targetpath" &&
tar -c . |docker import - lil_wharfie:testing &&
cd ".." &&
rm -rf "$targetpath" &&
echo "All done!"
