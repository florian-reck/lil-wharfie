FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -yq install python3-ldap python3-yaml unbound dnsmasq dnsutils

#copy pre configuration
COPY etc/unbound/unbound.conf.d/* /etc/unbound/unbound.conf.d/

# no global users necessary
RUN patch -R /etc/nsswitch.conf < /tmp/nsswitch.conf.patch

# copy necessary scripts 
COPY usr/local/bin/* /usr/local/bin/

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
ENTRYPOINT /etc/dockerinit