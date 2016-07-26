#
# @see http://www.tecmint.com/install-latest-mysql-on-rhel-centos-and-fedora/
#

FROM local/df/wb/centos/7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7/rdbs/mysql56" \
      com.container.priority="1" \
      com.container.project="df-wb-sample-02" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7/rdbs/mysql56" \
      img.description="our database service container using mysql 5.6.n"

# setup additional path sctructure
RUN mkdir -p /opt/docker

# setup yum repository and (local)install mysql 5.6 community package(s)
RUN cd /tmp && wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm && \
    yum localinstall -y mysql57-community-release-el7-7.noarch.rpm && \
    yum-config-manager --disable mysql57-community && \
    yum-config-manager --enable mysql56-community && \
    yum install -y mysql-community-server && \
    yum autoremove -y && \
    yum clean all

# setup/systemctl activate mysql (mysql 5.6.n)
RUN systemctl enable mysqld.service

EXPOSE 3306

# setup/exec behaviour of this container including shareable data path for mysql
VOLUME /sys/fs/cgroup /run /tmp /var/lib/mysql
CMD ["/lib/systemd/systemd"]
