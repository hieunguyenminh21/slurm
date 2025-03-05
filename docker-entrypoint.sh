#!/bin/bash

# Existing commands
sudo chown munge:munge /etc/munge/munge.key
sudo chown munge:munge /etc/munge
sudo service munge start
sudo service slurmctld start
sudo service ssh start

tail -f /dev/null