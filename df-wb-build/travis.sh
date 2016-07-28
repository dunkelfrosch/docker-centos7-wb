#!/usr/bin/env bash
#
# travis build/check helper script, feel free to extend|improve me ;)
#
# @copyright (c) 2016 Patrick Paechnatz <patrick.paechnatz@gmail.com>
# @author patrick.paechnatz@gmail.com
# @updated 2016/27/07
# @version 1.0.0
#

# activate strict mode for bash
set -e

# some default definitions
VERSION="1.0.0"

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

_image_build() {

    img_name=""
    img_path=""

    while [[ ${1} ]]; do

        case "${1}" in
            img|--image-name)
                img_name="${2}"
                shift
                ;;
            path|--image-path)
                img_path="${2}"
                shift
                ;;

        esac
        if ! shift; then
            echo "missing parameter arguments!" >&2
            return 1
        fi
    done

   cd ${img_path} && docker build -t ${img_name} . && cd ..
    _image_build_check img ${img_name}
}

_image_build_check() {

    img_name=""
    img_cnt=""

    case "${1}" in
        img|--image-name)

            img_name="${2}"
            img_cnt=$(docker images | grep "^$img_name" | wc -l)
            if [ $img_cnt -eq 0 ]; then
                echo -e "\n\033[0;31m[FAILURE] previously generated image ${img_name} not found!\033[0m <EXIT>\n"
                _docker_image_clear
                exit 9
            else
                echo -e "\n\033[1;92m[SUCCESS] image successfully generated -> ${img_name}\033[0m\n";
            fi

            shift
        ;;

    esac
}

_docker_container_clear() {
    echo -e "\n\033[1;92m [PREPARE] remove all container \033[0m";
    docker rm -fv $(docker ps -a -q)
}

_docker_image_clear() {
    echo -e "\n\033[1;92m [PREPARE] remove all dangling images \033[0m";
    docker images -q --filter "dangling=true" | xargs docker rmi -f
}

#
# ---------------------------------------------------------------------------------------------------------------------
#

_show_title

cd ..

_image_build --image-name "local/df/wb/centos/7" --image-path "./df-wb-centos-7"
_image_build --image-name "local/df/wb/centos/7/rdbs/mysql56" --image-path "./df-wb-rdbs-mysql56"
_image_build --image-name "local/df/wb/centos/7/rdbs/mysql57" --image-path "./df-wb-rdbs-mysql57"
_image_build --image-name "local/df/wb/centos/7/rdbs/postresql93" --image-path "./df-wb-rdbs-postgresql93"
_image_build --image-name "local/df/wb/centos/7/rdbs/postresql95" --image-path "./df-wb-rdbs-postgresql95"
_image_build --image-name "local/df/wb/centos/7/httpd/apache" --image-path "./df-wb-httpd-apache"
_image_build --image-name "local/df/wb/centos/7/httpd/apache/php56" --image-path "./df-wb-httpd-apache-php56"
_image_build --image-name "local/df/wb/centos/7/httpd/apache/php70" --image-path "./df-wb-httpd-apache-php70"
_image_build --image-name "local/df/wb/centos/7/httpd/apache/php70/app" --image-path "./df-wb-app"
