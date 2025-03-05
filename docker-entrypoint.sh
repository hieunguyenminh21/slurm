#!/bin/bash

# Mount cgroup v1 thay vì v2
mount -t tmpfs cgroup_root /sys/fs/cgroup
mkdir -p /sys/fs/cgroup/cpu
mkdir -p /sys/fs/cgroup/memory
mkdir -p /sys/fs/cgroup/devices
mount -t cgroup -o cpu none /sys/fs/cgroup/cpu
mount -t cgroup -o memory none /sys/fs/cgroup/memory
mount -t cgroup -o devices none /sys/fs/cgroup/devices

# Existing commands
sudo chown munge:munge /etc/munge/munge.key
sudo chown munge:munge /etc/munge
sudo service munge start
sudo service slurmctld start
sudo service ssh start

tail -f /dev/null