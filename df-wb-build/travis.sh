#!/usr/bin/env bash
#
# travis build/check helper script, feel free to extend|improve me ;)
#
# info: this script wont be necessary anymore, will be (re)used in later releases
#
# @copyright (c) 2016 Patrick Paechnatz <patrick.paechnatz@gmail.com>
# @author patrick.paechnatz@gmail.com
# @updated 2016/29/07
# @version 1.0.1
#

# activate strict mode for bash
set -e

# some default definitions
VERSION="1.0.1"

# some default configuration constants
SCRIPT_PATH=$(dirname "$0")

_show_title() {
    echo -e "\n\033[1;92mTRAVIS Build Helper v$VERSION \033[0m"
    echo -e "copyright (c) 2015-2016 Patrick Paechnatz <patrick.paechnatz@gmail.com>\n"
}

_image_destroy() {

    img_name=""

    case "${1}" in
        img|--image-name)

            img_name="${2}"
            docker
            docker rmi -f ${img_name}

            shift
        ;;

    esac
}

_container_check() {

    img_name=""
    cnt_name=""
    cnt_uid=""
    service_count=0

    while [[ ${1} ]]; do

        case "${1}" in
            img|--image-name)
                img_name="${2}"
                shift
                ;;

            container|--container-name)
                cnt_name="${2}"
                shift
                ;;

            scount|--container-service-count)
                service_count="${2}"
                shift
                ;;
        esac
        if ! shift; then
            echo "missing parameter arguments!" >&2
            return 1
        fi
    done

    cnt_uid=$(docker run --privileged -itd \
               --name="${cnt_name}" \
               --cap-add=SYS_ADMIN \
               --security-opt=seccomp:unconfined \
               --stop-signal=SIGRTMIN+3 \
               --volume=/sys/fs/cgroup:/sys/fs/cgroup \
               ${img_name})

    if ! docker top ${cnt_uid} &>/dev/null
    then
        echo -e "\n\033[0;31m[FAILURE] started container ${img_name} crashed unexpectedly!\033[0m <EXIT>\n"
        return 1
    fi

    echo "wait 3 seconds before service check ..."; sleep 3s
   _cnt=$(docker logs ${cnt_name} | grep '\[*OK' | wc -l)
    if [ $_cnt -eq ${service_count} ]; then
        echo -e "\033[1;92m[SUCCESS] all required systemd services loaded -> ${img_name} <${cnt_name}>\033[0m";
    else
        echo -e "\n\033[0;31m[FAILURE] NOT all service loaded successfully! -> ${img_name} <${cnt_name}>\033[0m <EXIT>\n"
        echo -e "          -> looking for ${service_count} services but found ${_cnt}\n" && docker logs ${cnt_name}
       _docker_container_clear
        exit 9
    fi

    echo "wait 1 second before container disarming ..."
    sleep 1s; _docker_container_clear
}

_docker_container_clear() {
    echo -e "\n\033[1;92mremove all container \033[0m";
    docker rm -fv $(docker ps -a -q)
}

_docker_image_clear() {
    echo -e "\n\033[1;92mremove all dangling images \033[0m";
    docker images -q --filter "dangling=true" | xargs docker rmi -f
}

#
# ---------------------------------------------------------------------------------------------------------------------
#

_show_title

cd ..

echo -e "\n - build all images necessary for this workbench ... \n"
echo "y" | ./dctl --build-all-images

echo -e "\n - check runtime availability for all microServices ... \n"
_container_check --image-name "local/df/wb/centos/7" --container-name "df-wb-centos7" --container-service-count 17 && \
_container_check --image-name "local/df/wb/centos/7/httpd/apache" --container-name "df-wb-centos7-httpd" --container-service-count 19 && \
_container_check --image-name "local/df/wb/centos/7/httpd/apache/php56" --container-name "df-wb-centos7-httpd-php56" --container-service-count 20 && \
_container_check --image-name "local/df/wb/centos/7/httpd/apache/php70" --container-name "df-wb-centos7-httpd-php70" --container-service-count 20 && \
_container_check --image-name "local/df/wb/centos/7/rdbs/mysql57" --container-name "df-wb-centos7-rdbs-mysql57" --container-service-count 19 && \
_container_check --image-name "local/df/wb/centos/7/rdbs/mysql56" --container-name "df-wb-centos7-rdbs-mysql56" --container-service-count 17 && \
_container_check --image-name "local/df/wb/centos/7/rdbs/postresql95" --container-name "df-wb-centos7-rdbs-pgsql95" --container-service-count 19 && \
_container_check --image-name "local/df/wb/centos/7/rdbs/postresql93" --container-name "df-wb-centos7-rdbs-pgsql93" --container-service-count 19
