FROM centos:7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7" \
      com.container.priority="1" \
      com.container.project="df-wb-sample-02" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7" \
      img.description="our main/core image definition using CentOS7 including usefull extensions and improvements"

# setup some system required environment variables
ENV TIMEZONE           "Europe/Berlin"
ENV TERM                xterm-color
ENV NCURSES_NO_UTF8_ACS 1
ENV LC_ALL              C
ENV LANG                en_US.UTF-8
ENV container           docker
ENV TRANSFER_USER       apache
ENV TRANSFER_GROUP      apache

# x-layer 1: <start> add transfer/vlume-share holder user (using apache/apache)
RUN adduser $TRANSFER_USER --home-dir /var/www --no-create-home --user-group --no-log-init --shell /bin/bash

# setup yum config, activate this line if you want docs for your packages
RUN sed -i -e "s/tsflags=nodocs/#tsflags=nodocs/g" /etc/yum.conf

# setup charset, language and timezone
RUN echo -e "LANG=en_US.UTF-8\nLC_ALL=C" > /etc/environment && \
    rm -rf /etc/localtime && \
    ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# setup basic yum packages
RUN yum -y update && \
    yum -y install systemd systemd-libs && \
    yum -y install which ntp mc htop vim-minimal less curl wget git && \
    yum autoremove -y && \
    yum clean all

# setup/activate systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# setup/systemctl activate ntpd (Network Time Service)
RUN systemctl enable ntpd.service
# setup/systemctl deactivate autofs
RUN systemctl disable autofs

# setup/exec behaviour of this container
VOLUME /sys/fs/cgroup /run /tmp
ENTRYPOINT ["/lib/systemd/systemd"] # <or> ["/usr/sbin/init"] <- symbolic link to /lib/systemd/systemd
CMD ["bash"]
