FROM lilwharfie_armhf_root:latest
MAINTAINER Florian Reck

# copy /etc stuff
COPY etc/*                      /etc/
COPY etc/profile.d/*            /etc/profile.d/
COPY etc/apt/*                  /etc/apt/
COPY etc/apt/sources.list.d/*   /etc/apt/sources.list.d/
COPY etc/apt/apt.conf.d/*       /etc/apt/apt.conf.d/
COPY etc/vim/vimrc              /etc/vim/vimrc

# remove unnecessary init systems (if they are installed)
RUN bash -c "apt-get -yq --force-yes purge init systemd systemd-sysv dmsetup <<< 'Yes, do as I say!'"
RUN apt-get -yq install pamtester build-essential openssh-client tmux wget zsh vim cvs git
RUN apt-get -yq clean

# install Grml shell
RUN wget -O "/tmp/zshrc" "http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc"
RUN cp -v /tmp/zshrc /etc/zsh/zshrc
RUN /bin/bash -c 'echo "source /etc/profile" >>/etc/zsh/zshenv'
RUN /usr/bin/chsh -s /usr/bin/zsh root 

# creating cron service for apt/unattended updates
RUN rm -fv /etc/cron.*/*apt*
RUN ln -fs /usr/lib/apt/apt.systemd.daily /etc/cron.daily


# clean up and create entrypoint
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
