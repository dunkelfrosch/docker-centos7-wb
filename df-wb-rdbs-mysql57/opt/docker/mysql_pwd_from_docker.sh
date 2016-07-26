#!/usr/bin/env bash
#
# @copyright (c) 2016 Patrick Paechnatz <patrick.paechnatz@gmail.com>
# @author patrick.paechnatz@gmail.com
# @updated 2016/03/06
# @version 1.0.0
#

# activate strict mode for bash
set -e

# get the logline entry for temporary chosen mysql password
LOG_TMP_PWD=$(docker exec -it me-bs-service-rdbs-mysql57 grep 'temporary password' /var/log/mysqld.log)

# split result into chunks, using " " as separator
IFS=' ' read -r -a LOG_TMP_ARRAY <<< "$LOG_TMP_PWD"

# print out the last chunk to fetch password
echo "${LOG_TMP_ARRAY[@]: -1:1}"
