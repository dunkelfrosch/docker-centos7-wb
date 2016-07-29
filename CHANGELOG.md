# CentOS 7.2.n - Docker Workbench 1.0.0

All notable changes of the DockerConfluence release series are documented in this file using the [Keep a CHANGELOG](http://keepachangelog.com/) principles.

_This ChangeLog documentation start with version 0.9.9 (2016-07-24)_

## [1.0.0], 2016-07-28:
_current_

### ADD
- travis ci build 
- travis image build check
- travis container microservice check
- extend command list of ./dctl

### CHANGE
- move travis.sh logic into ./dctl-CLI helper
- minor travis.yml exec improvements

### FIX
- minor documentation issues
- naming issue in diverse local container startUp scripts

## [0.9.9], 2016-07-24:

### ADD
- providing base os image (CentOS/7.2.n)
- providing base httpd image (Apache/2.4.6)
- providing base php 5.6 image (PHP/5.6.23)
- providing base php 7.0 image (PHP/7.0.8)
- providing base mysql 5.6 image (MySQL/5.6.n)
- providing base mysql 5.7 image (MySQL/5.7.n)
- providing base postgresql 9.3 image (Postgres/9.3.n)
- providing base postgresql 9.5 image (Postgres/9.5.n)
- providing base application data container (Symfony 3.1.n)
