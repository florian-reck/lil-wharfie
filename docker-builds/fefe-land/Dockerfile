FROM lil_wharfie:testing
MAINTAINER Florian Reck

#install necessary packages
RUN apt-get -yq install ncurses-dev libcrypt2 libcrypt2-dev zlib1g-dev libssl-dev libmbedtls-dev libmbedtls12 libmbedtls10 file

#login w/o password
RUN bash -c "cvs -d cvs -d :pserver:cvs:@cvs.fefe.de:/cvs login"

#build tinylibc
RUN bash -c "cd /usr/src; cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co dietlibc"
RUN bash -c "cd /usr/src/dietlibc; make && make install"

#build libowfat
RUN bash -c "cd /usr/src; cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat"
RUN bash -c "cd /usr/src/libowfat; make && make install"


#build tinyldap
RUN bash -c "cd /usr/src; cvs -d cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co tinyldap"
RUN bash -c "cd /usr/src/tinyldap; make"

#build gatling
RUN bash -c "cd /usr/src; cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co gatling"
RUN bash -c "cd /usr/src/gatling; make && make install"

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
