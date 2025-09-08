#!/bin/bash

set -eu

exec >/var/log/post-start.log 2>&1

/app/bootstrap.sh 
/app/lldap_set_password --username client --base-url http://localhost:17170 --admin-password ${LLDAP_LDAP_USER_PASS} --password ${LLDAP_DEFAULT_AUTH_TOKEN}
