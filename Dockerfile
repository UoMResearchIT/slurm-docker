FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    curl \
    less syslog-ng-core \
    mailutils \
    nano pwgen \
    openssh-client \
    openssh-server \
    slurm-client \
    slurm-wlm-doc \
    slurm-wlm-doc \
    slurmctld \
    slurmd \
    sssd-ldap \
    sssd-tools \
    emacs-nox \
    && rm -rf /var/lib/apt/lists/*

COPY bin/docker-entrypoint.sh /etc/slurm-llnl/
COPY etc/slurm.conf /etc/slurm-llnl/
COPY etc/sssd.conf /etc/sssd/sssd.conf
COPY etc/defaults_sssd /etc/default/sssd
COPY examples /usr/share/slurm-examples
COPY etc/sshd_hostkeys.conf /etc/ssh/sshd_config.d/hostkeys.conf
RUN mkdir /etc/ssh/keys
RUN chmod u=rw,g=,o= /etc/sssd/sssd.conf
RUN useradd -ms /bin/bash user
RUN pam-auth-update --enable mkhomedir

RUN mkdir /state
RUN chown slurm:slurm /state

RUN mkdir /scratch
RUN chown slurm:slurm /state

RUN mkdir /scratch/user
RUN chown user:user /scratch/user

# Install LAMMPS

RUN mkdir /opt/lammps && curl https://download.lammps.org/static/lammps-linux-x86_64-12Jun2025.tar.gz | tar xz --strip-components 1 -C /opt/lammps
RUN cp -a /opt/lammps/etc/profile.d/lammps.sh /etc/profile.d && echo 'export PATH=/opt/lammps/bin:$PATH' >>/etc/profile.d/lammps.sh

CMD ["/etc/slurm-llnl/docker-entrypoint.sh"]
