FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -qy update
RUN apt-get -qy upgrade
RUN apt-get -yq install python3-ldap python3-yaml lighttpd php-cgi php-imagick php-curl php-gd php-pear php-ldap php-intl libphp-phpmailer php-sabre-dav php-xml php-zip php-gd php-curl php-mysql php-sqlite3 mariadb-server mariadb-client php-redis redis-server redis-tools smbclient unzip php-mbstring php-seclib php-pimple php-apcu php-smbclient
ADD etc/lighttpd /etc/lighttpd
ADD etc/php/7.3/cgi/php.ini /etc/php/7.3/cgi

# copy necessary scripts 
COPY usr/local/bin/* /usr/local/bin/
RUN wget -O /opt/nextcloud.zip "https://download.nextcloud.com/server/releases/nextcloud-16.0.1.zip"
RUN cd /opt; unzip nextcloud.zip
RUN lighttpd-enable-mod fastcgi-php
RUN lighttpd-enable-mod ssl
#RUN lighttpd-enable-mod ssl-hsts
RUN lighttpd-enable-mod nextcloud

# clean up and create entrypoint
RUN rm -f /opt/nextcloud.zip
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
