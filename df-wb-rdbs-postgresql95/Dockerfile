#
# @see http://tecadmin.net/install-postgresql-9-5-on-centos/
#

FROM local/df/wb/centos/7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7/rdbs/postresql93" \
      com.container.priority="1" \
      com.container.project="df-wb-sample-02" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7/rdbs/postresql95" \
      img.description="our database service container using PostreSQL 9.5.n"

ENV INIT_PG_DATA /var/lib/pgsql/9.5/data/

# setup additional path sctructure
RUN mkdir -p /opt/docker

# setup yum repository and (local)install postreSQL 9.5.n package(s)
RUN rpm -Uvh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm && \
    yum -y update && \
    yum -y install postgresql95 postgresql95-server postgresql95-libs postgresql95-contrib postgresql95-devel && \
    yum clean all

# setup postres database structure
USER postgres
RUN /usr/pgsql-9.5/bin/pg_ctl initdb -D $INIT_PG_DATA
# -o --encoding=utf8 --locale=en_US.UTF-8 --nosync --pgdata $INIT_PG_DATA

# setup/systemctl activate postgre (postreSQL 9.5.n)
USER root
RUN systemctl enable postgresql-9.5

EXPOSE 5432

# setup/exec behaviour of this container including shareable data path for mysql
VOLUME /sys/fs/cgroup /run /tmp /var/lib/mysql
CMD ["/lib/systemd/systemd"]
