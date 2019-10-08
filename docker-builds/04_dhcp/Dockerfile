FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -yq update && apt-get -yq full-upgrade
RUN apt-get -yq install python3-ldap python3-yaml unbound dnsmasq dnsutils golang build-essential git

#copy pre configuration
COPY etc/unbound/unbound.conf.d/* /etc/unbound/unbound.conf.d/

# no global users necessary
RUN patch -R /etc/nsswitch.conf < /tmp/nsswitch.conf.patch

# copy necessary scripts 
COPY usr/local/bin/* /usr/local/bin/

# build DoH server
RUN cd /opt; git clone --depth=1 "https://github.com/m13253/dns-over-https"
RUN cd /opt/dns-over-https; make && make install && rm -rf /opt/dns-over-https;
COPY etc/dns-over-https/doh-server.conf /etc/dns-over-https/doh-server.conf

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
