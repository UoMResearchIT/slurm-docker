#!/bin/bash

set -e

/docker-entrypoint-common.sh

unset LLDAP_DEFAULT_AUTH_TOKEN

touch /var/log/slurm-llnl/accounting.log
chown slurm:slurm /var/log/slurm-llnl/accounting.log
chmod a+r /var/log/slurm-llnl/accounting.log

service slurmctld start

while [ ! -r "/var/log/syslog" ]; do
    sleep 1
done

tail -f -n 10000 /var/log/syslog
