FROM ubuntu:20.04 AS base

ARG DEBIAN_FRONTEND=noninteractive

RUN yes | unminimize

RUN apt-get update && apt-get install -y \
    man \
    curl \
    less syslog-ng-core \
    mailutils \
    nano pwgen \
    openssh-client \
    openssh-server \
    slurm-client \
    slurm-wlm-doc \
    slurm-wlm-doc \
    sssd-ldap \
    sssd-tools \
    emacs-nox \
    bsdmainutils \
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY etc/slurm.conf /etc/slurm-llnl/
COPY etc/sssd.conf /etc/sssd/sssd.conf
COPY etc/defaults_sssd /etc/default/sssd
COPY examples /usr/share/slurm-examples
COPY etc/sshd_hostkeys.conf /etc/ssh/sshd_config.d/hostkeys.conf
RUN mkdir /etc/ssh/keys
RUN chmod u=rw,g=,o= /etc/sssd/sssd.conf
RUN useradd -ms /bin/bash user
RUN pam-auth-update --enable mkhomedir

RUN chmod -x /etc/update-motd.d/*

RUN mkdir /scratch
RUN mkdir /scratch/user
RUN chown user:user /scratch/user

RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime

FROM base AS compute

RUN apt-get update && apt-get install -y \
    slurmd \
    && rm -rf /var/lib/apt/lists/*

CMD ["/docker-entrypoint-compute.sh"]


FROM base AS login

RUN apt-get update && apt-get install -y \
    rsync \
    && rm -rf /var/lib/apt/lists/*
CMD ["/docker-entrypoint-login.sh"]

FROM base AS slurm

RUN apt-get update && apt-get install -y \
    slurmctld \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /state
RUN chown slurm:slurm /state

CMD ["/docker-entrypoint-slurm.sh"]
