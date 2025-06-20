FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    slurm-client \
    slurm-wlm-doc \
    slurmd \
    openssh-client \
    slurmctld \
    slurm-wlm-doc \
    mailutils \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    less syslog-ng-core \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    nano pwgen \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    sssd-ldap \
    && rm -rf /var/lib/apt/lists/*

COPY bin/docker-entrypoint.sh /etc/slurm/
COPY etc/slurm.conf /etc/slurm/
COPY etc/sssd.conf /etc/sssd/sssd.conf
COPY examples /usr/share/slurm-examples

RUN chmod u=rw,g=,o= /etc/sssd/sssd.conf
RUN useradd -ms /bin/bash user
RUN pam-auth-update --enable mkhomedir

RUN mkdir /state
RUN chown slurm:slurm /state

RUN mkdir /scratch
RUN chown slurm:slurm /state

RUN mkdir /scratch/user
RUN chown user:user /scratch/user

CMD ["/etc/slurm/docker-entrypoint.sh"]
