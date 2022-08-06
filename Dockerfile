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
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    unzip python3 python3-pip python-is-python3  \
    && rm -rf /var/lib/apt/lists/*

COPY bin/docker-entrypoint.sh /etc/slurm-llnl/
COPY etc/slurm.conf /etc/slurm-llnl/

RUN useradd -ms /bin/bash user

RUN echo 'user:ughiFail1EiF' | chpasswd

RUN mkdir /state
RUN chown slurm:slurm /state

RUN mkdir /scratch
RUN chown slurm:slurm /state

RUN mkdir /scratch/user
RUN chown user:user /scratch/user

CMD ["/etc/slurm-llnl/docker-entrypoint.sh"]
