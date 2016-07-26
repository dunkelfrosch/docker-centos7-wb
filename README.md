# CentOs 7.2.n Docker Workbench v0.9.9
*this documentation isn't fully done yet - we're still working on major and minor issues corresponding to this repository base!*

This repository provides the latest version of [CentOs 7.2.n](https://www.centos.org/) (SystemD/CTL) as docker-compose workbench dev teams runnable under OSX10 and containing the following services:

- base os image (CentOS/7.2.n)
- base httpd image (Apache/2.4.6)
- base php 5.6 image (PHP/5.6.23)
- base php 7.0 image (PHP/7.0.8)
- base mysql 5.6 image (MySQL/5.6.n)
- base mysql 5.7 image (MySQL/5.7.n)
- base postgresql 9.3 image (Postgres/9.3.n)
- base postgresql 9.5 image (Postgres/9.5.n)
- base application data container (Symfony 3.1.n)

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![System Version](https://img.shields.io/badge/version-0.9.9-blue.svg)](VERSION)


## Preparation
We recommend the [latest Docker version](https://github.com/docker/docker/blob/master/CHANGELOG.md). For simple system integration and supervision we suggest [Docker Compose](https://docs.docker.com/compose/install/). If you're using MacOS or Windows as host operating system, you may take the advantage of [Docker Machine](https://www.docker.com/docker-machine) for Docker's VM management. Use the installation guides of provided links down below to comply your Docker preparation process.

- visit [docker installation guide](https://docs.docker.com/engine/installation/)
- visit [docker-compose installation guide](https://docs.docker.com/compose/install/)
- visit [docker-machine installation guide](https://docs.docker.com/machine/install-machine/)


## MacOS, install local docker-machine
We recommend the usage of docker-machine instead of native boot2docker vm image buildUp. So please generate your own docker-machine ... 

1.1) using the following command to build your "dev" vm for docker:

```$
docker-machine create --driver virtualbox dev
```

1.2) check vm status by typing the following command:

```$
docker-machine ls
```

[![DM Status](https://dl.dropboxusercontent.com/s/2kggingr902e996/ssh-dm-status-001.png)](STATUS)

- status should be "running"

1.3) improve your vm by edit the base "dev" vm json.config (~/.docker/machine/machines/<name-of-you-machine/config.json)

[![DM Config](https://dl.dropbox.com/s/vpciez0a5katnu6/ssh-dm-config-001.png)](CONFIG)

- change values for CPU, Memory (and DiskSize) at your needs

1.4) reload your docker-machine after any changes of this file by executing the following command:

```$
docker-machine restart
```

1.5) bound your shell to docker-machine config (vm) executing the following command inside any active shell you want to use docker command(s) and eval the resulting command-line

```$
docker-machine env <name-of-your-machine>
```

[![DM Config](https://dl.dropbox.com/s/tnlqjwi09h948qo/ssh-dm-env-001.png)](CONFIG)


1.6) check docker-machines internal upgrade features for new/upcoming version of docker/dm

```$
docker-machine upgrade <name-of-your-machine>
```

*take note, that docker-machine is loosing net gateway config after switching from company network to your home network configuration - in this case you'll get errors during image recreation messaging that connection to update server is lost. Please reboot your VM on any network change!*


## MacOS/Linux: building all images

2.1) run the following command inside your console

```$
./dctl --build-all-images
```

2.2) check your image stack typing the following command, the result should be equal to our screenshot chown below:

```$
docker images
```

[![DM Config](https://dl.dropbox.com/s/vy4mkjpqtzjm7pc/ssh-dkr-images-001.png)](CONFIG)


2.2) run docker-compose to start our sample workbench

```$
./docker-compose up -d
```

2.3) check systemd status logs for error-free running of mysql and http/php7/app container

*the result should be equals to the screenshot below each command*

```$
./docker logs df-wb-app
```

[![Docker Logs 01](https://dl.dropbox.com/s/1ehutkrv6teau6b/ssh-dkr-systemd-logs-01-001.png)](APP)

```$
./docker logs df-wb-app-mysql
```

[![Docker Logs 02](https://dl.dropbox.com/s/2hcnoa8x8rbt94v/ssh-dkr-systemd-logs-02-001.png)](MYSQL)


## MacOS/Linux: prepare your host configuration
this sample workbench using a simple symfony 3.1 installation for testing purposes. The corresponding apache vhost config point out the following named configuration:

| server name             | server alias        | ip (etc/hosts                                              |
| ----------------------- |:-------------------:| ----------------------------------------------------------:|
| www.dunkelfrosch.intern | dunkelfrosch.intern | 192.168.99.100 dunkelfrosch.intern www.dunkelfrosch.intern |

*the ip 192.168.99.100 will be used directly from our docker-machine environment definition and must be evaluated from time to time! You can change the values for server-alias and server-name directly inside our ```./df-wb-app/etc/httpd/conf.d/app.conf``` project container configuration - please rebuild the corresponding image after your changes were made! *


## MacOS/Linux: test your symfony endpoint
call the your project url www.dunkelfrosch.intern (or in debug mode: www.dunkelfrosch.intern/app_dev.php) and you should see the following page:

[![Docker Start 01](https://dl.dropbox.com/s/yrhug745l97t3ar/ssh-dkr-site-001.png)](MYSQL)


## Additional information

### quick access to our workbench microservices
you've always access to our microservice instance(s) by using the ```$ start``` script inside the corresponding service path. the system will start a dedicated service instance and ask you direct login after start ... feel free to use it. *be aware, the docker-compose should not be running at the same time! otherwise you'll got an error, that the named service is already in use*

[![Docker Start 01](https://dl.dropbox.com/s/rf425jhz3f43w4v/ssh-dkr-start-01-001.png)](MYSQL)
- in this case we've start our mysql 5.7 container directly using our ```$ start``` command


### docker-control script extension
we've create a simple docker-control bash script for this workbench. You can find this file inside the root path of this project named ```.dctl```. Feel free to extend that file for your needs, currently we've implement the following helpful commands for your local docker/wb handling:

```$
./dctl bai | --build-all-images
```
 -> build all images inside this workbench

```$
./dctl rec | --remove-exited-container
```
 -> remove all exited containers including ofs volumes

```$
./dctl rac | --remove-all-container
```
 -> remove all (!) containers including 'ofs' volumes

```$
./dctl rdi | --remove-dangling-images
```
 -> emove all dangling <none>/<incomplete> images
 

### systemd issues on mac
we're using CentOS 7.2 with systemd instead of initd as bootloading service provider. There are still issues using systemd docker microservices inside MacOS/DM on Mac! In some cases you're get the following message on ```docker logs <systemd-container-name>```:

> Failed to mount cgroup at /sys/fs/cgroup/systemd: Permission denied
> [!!!!!!] Failed to mount API filesystems, freezing.
> Freezing execution.

or this one ... 

> [!!!!!!] Failed to mount API filesystems, freezing.

- in both cases delete the container and image, rebuild your image(s) and restart your docker-machine and start container again


### usage of systemd
any service inside our container will be handled by systemd. if you want further/detailed information about a specific service you can call him using the following command (in this case we've logged into your mysql57 service container)

[![Docker Systemd-Start 01](https://dl.dropbox.com/s/yl87dqseqk262nm/ssh-dkr-systemd-mysql-001.png)](MYSQL)


## License-Term

This workbench is based on dunkelfrosch GIT Repository [docker-centos7-wb](https://github.com/dunkelfrosch/docker-centos7-wb) 0.9.9 

Copyright (c) 2015-2016 Patrick Paechnatz <patrick.paechnatz@gmail.com>
                                                                           
Permission is hereby granted,  free of charge,  to any  person obtaining a 
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction,  including without limitation
the rights to use,  copy, modify, merge, publish,  distribute, sublicense,
and/or sell copies  of the  Software,  and to permit  persons to whom  the
Software is furnished to do so, subject to the following conditions:       
                                                                           
The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.
                                                                           
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING  BUT NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR  PURPOSE AND  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,  WHETHER IN AN ACTION OF CONTRACT,  TORT OR OTHERWISE,  ARISING
FROM,  OUT OF  OR IN CONNECTION  WITH THE  SOFTWARE  OR THE  USE OR  OTHER DEALINGS IN THE SOFTWARE.