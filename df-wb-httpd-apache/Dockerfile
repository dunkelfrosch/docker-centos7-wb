FROM local/df/wb/centos/7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7/httpd/apache" \
      com.container.priority="1" \
      com.container.project="df-wb-sample-02" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7/httpd/apache" \
      img.description="our httpd service container using apache2"

# setup service related yum packages
RUN yum -y update && \
    yum -y install httpd && \
    yum autoremove -y && \
    yum clean all

# setup/systemctl activate httpd (apache2)
RUN systemctl enable httpd.service

EXPOSE 80

# setup/exec behaviour of this container
VOLUME /sys/fs/cgroup /run /tmp
CMD ["/lib/systemd/systemd"]
