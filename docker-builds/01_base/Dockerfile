FROM lilwharfie_root:armhf
MAINTAINER Florian Reck

# copy /etc stuff
COPY etc/*                      /etc/
COPY etc/profile.d/*            /etc/profile.d/
COPY etc/apt/*                  /etc/apt/
COPY etc/apt/sources.list.d/*   /etc/apt/sources.list.d/
COPY etc/apt/apt.conf.d/*       /etc/apt/apt.conf.d/
COPY etc/cron.d/*               /etc/cron.d/
COPY etc/vim/vimrc              /etc/vim/vimrc
COPY tmp/*                      /tmp/

# create predefined groups and system users used in all child containers
RUN addgroup --system --gid 999 ssl-cert

# remove unnecessary init systems (if they are installed)
RUN bash -c "apt-get -yq --force-yes purge init systemd systemd-sysv dmsetup <<< 'Yes, do as I say!'"
RUN apt-get -yq install openssh-client tmux wget zsh vim file busybox-syslogd patch binutils diffutils anacron python3-gi

# install tools for using ldap together with pam
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -yq update && apt-get -yq full-upgrade
RUN apt-get -yq install libnss-ldap ldap-utils
RUN apt-get -yq clean
COPY usr/local/bin* /usr/local/bin

# pre-setup pam_ldap and libnss stuff
RUN mv /etc/libnss-ldap.conf /etc/libnss-ldap.conf-dpkg
RUN mv /etc/pam_ldap.conf /etc/pam_ldap.conf-dpkg
RUN ln -fs /storage/ldap/etc/libnss-ldap.conf   /etc/libnss-ldap.conf
RUN ln -fs /storage/ldap/etc/libnss-ldap.conf   /etc/pam_ldap.conf
RUN ln -fs /storage/ldap/etc/libnss-ldap.secret /etc/libnss-ldap.secret
RUN ln -fs /storage/ldap/etc/libnss-ldap.secret /etc/pam_ldap.secret
RUN ln -fs /storage/ldap/etc/ldap/ldap.conf     /etc/ldap/ldap.conf
RUN patch -p1 /etc/nsswitch.conf < /tmp/nsswitch.conf.patch
RUN patch -p1 /etc/pam.d/common-session < /tmp/common-session.patch
RUN patch -p1 /etc/pam.d/common-password < /tmp/common-password.patch

# install Grml shell
RUN wget -O "/tmp/zshrc" "http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc"
RUN cp -v /tmp/zshrc /etc/zsh/zshrc
RUN /bin/bash -c 'echo "source /etc/profile" >>/etc/zsh/zshenv'
RUN /usr/bin/chsh -s /usr/bin/zsh root 

# creating cron service for apt/unattended updates
RUN rm -fv /etc/cron.*/*apt*
RUN ln -fs /usr/lib/apt/apt.systemd.daily /etc/cron.daily

# clean up and create entrypoint
RUN apt-get -yq autoclean
RUN apt-get -yq clean
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
RUN /bin/bash -c "grep -Pqe '^\s*en_US.UTF-8' /etc/locale.gen || echo 'en_US.UTF-8 UTF-8' >>/etc/locale.gen"
RUN /usr/sbin/locale-gen
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
WORKDIR /root
RUN chmod 744 /etc/docker-init
ENTRYPOINT /etc/docker-init
