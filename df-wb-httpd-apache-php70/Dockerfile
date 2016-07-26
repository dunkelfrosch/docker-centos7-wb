#
# @see https://webtatic.com/packages/php70/
#
FROM local/df/wb/centos/7/httpd/apache

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="df/wb/centos/7/httpd/apache/php70" \
      com.container.priority="1" \
      com.container.project="df-wb-sample-02" \
      img.version="0.9.9" \
      img.name="local/df/wb/centos/7/httpd/apache/php70" \
      img.description="our httpd service container using apache2 and php 7.0.8"

ENV PROJECT_DOCUMENT_ROOT /var/www/sources/app
ENV PROJECT_SERVER_NAME    www.dunkelfrosch.intern
ENV PROJECT_SERVER_ALIAS   dunkelfrosch.intern
ENV PROJECT_SERVER_PORT    80
ENV PROJECT_SERVER_USER    apache
ENV PROJECT_SERVER_GROUP   apache
ENV PROJECT_PHP_HANDLER    proxy:fcgi://127.0.0.1:9000

# setup yum repository base
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# setup service related yum packages
RUN yum -y update && \
    yum install -y \
        gcc make openssl-devel \
        php70w-fpm \
        php70w-cli \
        php70w-devel \
        php70w-bcmath \
        php70w-opcache \
        php70w-common \
        php70w-xml \
        php70w-mbstring \
        php70w-mcrypt \
        php70w-pdo \
        php70w-mysql \
        php70w-pgsql \
        php70w-gd \
        php70w-intl \
        php70w-pear \
        php70w-pecl-xdebug \
        php70w-pecl-imagick && \
        yum clean all

# setup pecl related php extensions
RUN printf "\n" | pecl install -f mongodb

# remove obsolete packages
RUN yum remove -y --setopt=clean_requirements_on_remove=1 gcc make openssl-devel -y && \
    yum autoremove -y && \
    yum clean all

# setup composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# setup httpd/php project config
RUN rm -rf /etc/httpd/conf.d/welcome.conf
COPY /etc/httpd/conf.d/app.conf /etc/httpd/conf.d/app.conf
COPY /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
COPY /etc/php.ini /etc/php.ini
COPY /etc/php.d/* /etc/php.d/

RUN set -e && \
    sed -i "s|%cfg_document_root%|$PROJECT_DOCUMENT_ROOT|g" /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_server_name%|$PROJECT_SERVER_NAME|g"     /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_server_alias%|$PROJECT_SERVER_ALIAS|g"   /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_php_handler%|$PROJECT_PHP_HANDLER|g"     /etc/httpd/conf.d/app.conf && \
    sed -i "s|%cfg_server_port%|$PROJECT_SERVER_PORT|g"     /etc/httpd/conf.d/app.conf

# setup sample php file for testing
RUN mkdir -p $PROJECT_DOCUMENT_ROOT && echo "<?php phpinfo();" > $PROJECT_DOCUMENT_ROOT/index.php

# setup access rights (nobody is bad practice, just for testing)
RUN chown -R $PROJECT_SERVER_USER:$PROJECT_SERVER_GROUP $PROJECT_DOCUMENT_ROOT

# setup/systemctl activate php-fpm (php56)
RUN systemctl enable php-fpm.service

# setup/exec behaviour of this container
VOLUME /sys/fs/cgroup /run /tmp
WORKDIR $PROJECT_DOCUMENT_ROOT
CMD ["/lib/systemd/systemd"]
