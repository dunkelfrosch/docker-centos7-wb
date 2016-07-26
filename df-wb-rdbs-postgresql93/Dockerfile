#
# @see http://www.liquidweb.com/kb/how-to-install-and-connect-to-postgresql-on-centos-7/
#

FROM local/df/wb/centos/7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7/rdbs/postresql93" \
      com.container.priority="1" \
      com.container.project="df-wb-sample-02" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7/rdbs/postresql93" \
      img.description="our database service container using PostreSQL 9.3.n"

# setup additional path sctructure
RUN mkdir -p /opt/docker

# setup yum repository and (local)install postreSQL 9.3.n package(s)
RUN rpm -iUvh http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm && \
    yum -y update && \
    yum -y install postgresql93 postgresql93-server postgresql93-libs postgresql93-contrib && \
    yum clean all

# setup/systemctl activate postgre (postreSQL 9.3.n)
RUN systemctl enable postgresql-9.3

# setup postres database structure
RUN /usr/pgsql-9.3/bin/postgresql93-setup initdb

EXPOSE 5432

# setup/exec behaviour of this container including shareable data path for mysql
VOLUME /sys/fs/cgroup /run /tmp /var/lib/mysql
CMD ["/lib/systemd/systemd"]
