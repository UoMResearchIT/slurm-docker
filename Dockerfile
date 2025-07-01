FROM ubuntu:20.04

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

COPY bin/docker-entrypoint.sh /etc/slurm-llnl/
COPY etc/slurm.conf /etc/slurm-llnl/
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

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install LAMMPS

RUN mkdir /opt/lammps && curl https://download.lammps.org/static/lammps-linux-x86_64-12Jun2025.tar.gz | tar xz --strip-components 1 -C /opt/lammps
RUN cp -a /opt/lammps/etc/profile.d/lammps.sh /etc/profile.d && echo 'export PATH=/opt/lammps/bin:$PATH' >>/etc/profile.d/lammps.sh

CMD ["/etc/slurm-llnl/docker-entrypoint.sh"]
