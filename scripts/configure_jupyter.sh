#!/bin/bash 
#
# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# The Universal Permissive License (UPL), Version 1.0
#

# Redirect stdout & stderr to syslog 

exec 1> >(logger -s -t $(basename $0)) 2>&1
# set -x

# conda info -e

cd /home/opc

source ~/anaconda3/etc/profile.d/conda.sh
conda activate sandbox 
touch /home/opc/completed.sandbox

# Set the password for Jupyter Notebooks
p_hash=$(python3 -c "from notebook.auth import passwd; print(passwd('welcome1'))")

# Start the notebooks with nohup. Needed so the notebooks don't
# exit when this script exits.
cmd="/home/opc/anaconda3/bin/jupyter notebook --NotebookApp.password=$p_hash --certfile=/home/opc/jupyter-cert.pem --keyfile=/home/opc/jupyter-key.key";
nohup ${cmd}  &

# Without this sleep command, the jupyter notebook command does not start.
# Not sure what the timing issue is, however, the sleep command resolves it.
sleep 5

touch /home/opc/completed.jupyter

sudo yum install -y git
git -C repo pull || git clone https://github.com/yumeng5/WeSHClass.git repo

touch /home/opc/completed.repo
