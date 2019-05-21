FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -yq install file slapd slapd-contrib libnss-ldap ldap-utils python3-ldap python3-yaml busybox-syslogd

#reconfigure OpenLDAP to use rfc2703bis schema
COPY etc/ldap/schema/* /etc/ldap/schema/
COPY tmp/* /tmp/
RUN rm -f /var/lib/ldap/*
RUN rm -rf /etc/ldap/slapd.d ; mkdir /etc/ldap/slapd.d; chown openldap:openldap /etc/ldap/slapd.d
RUN patch -p1 /usr/share/slapd/slapd.conf < /tmp/slapd.conf.patch
RUN patch -p1 /usr/share/slapd/slapd.init.ldif < /tmp/slapd.init.ldif.patch
RUN dpkg-reconfigure slapd


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
