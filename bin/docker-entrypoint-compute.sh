#!/bin/bash

set -e

/docker-entrypoint-common.sh

unset LLDAP_DEFAULT_AUTH_TOKEN

mkdir -p /etc/slurm-llnl/nodes
slurmd -C | head -n 1 >/etc/slurm-llnl/nodes/nodes.conf
chown slurm:slurm /etc/slurm-llnl/nodes/nodes.conf

service slurmd start

while [ ! -r "/var/log/syslog" ]; do
    sleep 1
done

tail -f -n 10000 /var/log/syslog
