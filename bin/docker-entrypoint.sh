#!/bin/bash

set -e

newpassword=$(pwgen -N 1 12)
chpasswd <<< "user:${newpassword}"

echo "Set password for 'user' to '$newpassword'"

service syslog-ng start
service munge start
service slurmctld start
service slurmd start
service ssh start

while [ ! -r "/var/log/syslog" ]; do
    sleep 1
done

tail -f -n 10000 /var/log/syslog
