#!/bin/bash 

#
# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# The Universal Permissive License (UPL), Version 1.0
#

# Redirect stdout & stderr to syslog 
exec 1> >(logger -s -t $(basename $0)) 2>&1

# Find the disks attached
num_disks=0
device_list=()

for i in /dev/sd*
  do
    if [[ $i != *"sda"* ]]
    then
      num_disks=$(expr $num_disks + 1)
      device_list+=( $i )
    fi
  done

echo $num_disks
echo ${device_list[*]}

# Configure raid 0 will all disks except boot device
sudo mdadm --create /dev/md0 --raid-devices=$num_disks --level=0 ${device_list[*]}

# Install the Cloud Harmony Benchmark available at: https://github.com/cloudharmony/block-storage
# sudo yum -y install fio-2.2.8-2.el7 gnuplot php-cli util-linux zip git xorg-x11-fonts-75dpi xorg-x11-fonts-Type1
# git clone https://github.com/cloudharmony/block-storage
# wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox-0.12.5-1.centos7.x86_64.rpm
# sudo rpm -i wkhtmltox-0.12.5-1.centos7.x86_64.rpm
# sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin

# To run the Cloud Harmony Benchmark, log into the VM and execute the 2 commands below.
# Grab your knitting while you are waiting for this command to complete. Not recommended
# in the automation because any network hiccup will leave the automation in an inconsistent state.

# ssh to VM using opc login
# cd block-storage
# sudo ./run.sh --target /dev/md0 --test=iops --nopurge --noprecondition --fio_direct=1 --fio_size=10g --skip_blocksize 512b --skip_blocksize 1m --skip_blocksize 8k --skip_blocksize 16k --skip_blocksize 32k --skip_blocksize 64k --skip_blocksize 128k

# Install fio 
sudo yum -y install fio
# As an alternative to get a sense of the iops, we use fio.  Optimize iops
# if you have lots of small files ( ie web log files )
# Find max iops:
sudo fio --filename=/dev/md0 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=64 --runtime=30 --numjobs=16 --time_based --group_reporting --name=client-max

# If you are more interested in the throughput try a larger blocksize. 
# This is generally if you are intersted in processing large files (images, video)
# for example:
# sudo fio --filename=/dev/md0 --direct=1 --rw=randwrite --bs=256k --ioengine=libaio --iodepth=64 --runtime=30 --numjobs=4 --time_based --group_reporting --name=client-max

# Finally, if you are interested in the latency, tweak the iodepth, for example:
# sudo fio --filename=/dev/md0 --direct=1 --rw=randrw --bs=4k --ioengine=libaio --iodepth=1 --runtime=30 --numjobs=1 --time_based --group_reporting --name=client-max


