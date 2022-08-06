#!/bin/bash

set -e

service syslog-ng start
service munge start
service slurmctld start
service slurmd start
service ssh start

while [ ! -r "/var/log/syslog" ]; do
    sleep 1
done

tail -f -n 10000 /var/log/syslog
