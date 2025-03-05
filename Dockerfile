#Base OS
FROM --platform=linux/amd64 ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y
# Install needed packages
RUN apt install munge nano build-essential git mariadb-server wget slurmd slurm-client slurmctld sudo openssh-server -y

# Add a user to manage everything, and be able to ssh (will be handy everywhere)
RUN useradd -m admin -s /usr/bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# This step, is more like a hack, I am sure there is a better way to do it. 
RUN echo 'OPTIONS="--force --key-file /etc/munge/munge.key"' > /etc/default/munge


# You could bind mount them also
COPY slurm.conf /etc/slurm/
COPY slurm.conf /etc/slurm-llnl/

# Script will be ther below
COPY docker-entrypoint.sh /etc/slurm/

#EXPOSE 6817 6818 6819 3306 

RUN chmod +x /etc/slurm/docker-entrypoint.sh 

COPY munge.key /etc/munge/

# Tạo thư mục log cho slurm
RUN mkdir -p /var/log/slurm && \
    chown -R slurm:slurm /var/log/slurm

# Tạo thư mục spool cho slurmd
RUN mkdir -p /var/spool/slurmd && \
    chown slurm:slurm /var/spool/slurmd && \
    chmod 755 /var/spool/slurmd

ENTRYPOINT ["/etc/slurm/docker-entrypoint.sh"]