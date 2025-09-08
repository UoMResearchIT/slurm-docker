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
newpassword=$(pwgen -N 1 12)
chpasswd <<< "user:${newpassword}"

echo "Set password for 'user' to '$newpassword'"

touch /var/log/slurm-llnl/accounting.log
chown slurm:slurm /var/log/slurm-llnl/accounting.log
chmod a+r /var/log/slurm-llnl/accounting.log

service syslog-ng start
service munge start
service slurmctld start
service slurmd start
service ssh start

rm -f /var/run/sssd.pid
service sssd start

while [ ! -r "/var/log/syslog" ]; do
    sleep 1
done

tail -f -n 10000 /var/log/syslog
