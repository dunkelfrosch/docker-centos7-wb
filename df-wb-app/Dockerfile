FROM local/df/wb/centos/7/httpd/apache/php70

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7/httpd/apache/php70/app" \
      com.container.priority="1" \
      com.container.project="me-bs/app" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7/httpd/apache/php70/app" \
      img.description="our app project data container using php 7.0.n"

ENV PROJECT_DOCUMENT_ROOT /var/www/sources/app
ENV PROJECT_SERVER_NAME    www.dunkelfrosch.intern
ENV PROJECT_SERVER_ALIAS   dunkelfrosch.intern
ENV PROJECT_SERVER_PORT    80
ENV PROJECT_SERVER_USER    apache
ENV PROJECT_SERVER_GROUP   apache
ENV PROJECT_PHP_HANDLER    proxy:fcgi://127.0.0.1:9000

# (re)setup httpd/php project config
COPY /etc/httpd/conf.d/app.conf /etc/httpd/conf.d/app.conf
COPY /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
COPY /etc/php.ini /etc/php.ini
COPY /etc/php.d/* /etc/php.d/

# (re)setup apache configuration for this app
RUN set -e && \
    sed -i "s|%cfg_document_root%|$PROJECT_DOCUMENT_ROOT|g" /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_server_name%|$PROJECT_SERVER_NAME|g"     /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_server_alias%|$PROJECT_SERVER_ALIAS|g"   /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_php_handler%|$PROJECT_PHP_HANDLER|g"     /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_server_port%|$PROJECT_SERVER_PORT|g"     /etc/httpd/conf.d/app.conf

# copy app source files to application document root and remove dummy php file from source image
# COPY /var/www/sources/app $PROJECT_DOCUMENT_ROOT
RUN chown $PROJECT_SERVER_USER:$PROJECT_SERVER_GROUP $PROJECT_DOCUMENT_ROOT -R && \
    rm -rf $PROJECT_DOCUMENT_ROOT/index.php

# setup/exec behaviour of this container
VOLUME /sys/fs/cgroup /run /tmp
WORKDIR $PROJECT_DOCUMENT_ROOT
CMD ["/lib/systemd/systemd"]