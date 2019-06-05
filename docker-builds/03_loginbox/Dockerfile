FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -yq install openssh-server xrdp samba-common-bin smbclient fluxbox feh terminator gnumeric abiword pcmanfm evince firefox-esr build-essential nmap dnsutils whois keepassxc apt-file 
COPY etc/xrdp/* /etc/xrdp/

# remove unnecessary init systems (if they are installed)
RUN bash -c "apt-get -yq --force-yes purge init systemd systemd-sysv dmsetup <<< 'Yes, do as I say!'"

# clean up and create entrypoint
RUN apt-get -yq clean
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
WORKDIR /root
COPY etc/dockerinit /etc/
RUN chmod 744 /etc/dockerinit
ENV DEBIAN_FRONTEND=
ENTRYPOINT /etc/dockerinit
