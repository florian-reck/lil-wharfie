FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -qy update
RUN apt-get -qy upgrade
RUN apt-get -yq install php python3-ldap python3-yaml lighttpd php-tokenizer php-mbstring php-xml php-json php-fpm php-cgi php-imagick php-curl php-gd php-pear php-ldap php-intl libphp-phpmailer php-sabre-dav php-xml php-zip php-gd php-curl php-mysql php-sqlite3 mariadb-server mariadb-client smbclient unzip php-mbstring php-seclib php-pimple php-apcu php-smbclient composer python3-flask
ADD etc/lighttpd /etc/lighttpd
ADD etc/php/7.3/cgi/php.ini /etc/php/7.3/cgi

# copy necessary scripts 
COPY usr/local/bin/* /usr/local/bin/
RUN wget -O /opt/strichliste.tar.gz "https://github.com/strichliste/strichliste/releases/download/v1.7.1/strichliste.tar.gz"
RUN mkdir -p /opt/strichliste; cd /opt; tar xf strichliste.tar.gz -C /opt/strichliste; chown -R www-data:www-data /opt/strichliste;
RUN lighttpd-enable-mod fastcgi-php
RUN lighttpd-enable-mod ssl
RUN lighttpd-enable-mod rewrite
RUN lighttpd-enable-mod strichliste

# clean up and create entrypoint
RUN rm -f /opt/strichliste.zip
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
