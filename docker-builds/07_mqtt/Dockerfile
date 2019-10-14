FROM lilwharfie_base:armhf
MAINTAINER Florian Reck
ENV DEBIAN_FRONTEND=noninteractive

#install necessary packages
RUN apt-get -yq update
RUN apt-get -yq install mosquitto
RUN adduser mosquitto ssl-cert
RUN ln -s /storage/certificates/*.pem /etc/mosquitto/certs

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
