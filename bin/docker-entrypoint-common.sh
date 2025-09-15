#!/bin/bash

set -e
authtokfile=/etc/sssd/conf.d/ldap-auth.conf
touch $authtokfile
chmod u=rw,g=,o= $authtokfile
cat <<EOF > $authtokfile
[domain/LDAP]
ldap_default_authtok = ${LLDAP_DEFAULT_AUTH_TOKEN}
EOF

unset LLDAP_DEFAULT_AUTH_TOKEN

service syslog-ng start
service munge start

rm -f /var/run/sssd.pid
service sssd start
