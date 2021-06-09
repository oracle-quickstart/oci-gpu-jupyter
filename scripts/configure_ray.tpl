#!/bin/bash 

#
# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# The Universal Permissive License (UPL), Version 1.0
#

# Redirect stdout & stderr to syslog 

exec 1> >(logger -s -t $(basename $0)) 2>&1
# set -x

cd /home/opc

source ~/mlenv/bin/activate
touch /home/opc/completed.mlenv

# sudo yum upgrade

# Install Oracle client libraries
sudo yum install -y oracle-instantclient18.3-basic.x86_64

# Upgrade pip to latest version
python -m pip install --upgrade pip

# Register mlenv with Python Notebooks as a kernel
pip install ipykernel
python -m ipykernel install --user --name=mlenv

# Misc. packages 
pip install jupyter-sql
pip install ipython-sql
pip install cx_oracle
pip install dm-tree
pip install opencv-python
pip install icecream
#pip install --upgrade torch
#pip uninstall torchvision
pip install --force-reinstall tensorflow==2.5
pip install ray[default]
pip install ray[rllib]
pip install ray[tune]

touch /home/opc/completed.pip.install

export ORACLE_HOME=/usr/lib/oracle/18.3/client64
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/bin/:$ORACLE_HOME/lib/

# Set the password for Jupyter Notebooks
p_hash=$(python3 -c "from notebook.auth import passwd; print(passwd('${jupyter_password}'))")

# Start the notebooks with nohup. Needed so the notebooks don't
# exit when this script exits.

cmd="jupyter notebook --ip=0.0.0.0 --port=8080 --NotebookApp.password=$p_hash ";
nohup $cmd  &

# Without this sleep command, the jupyter notebook command does not start.
# Not sure what the timing issue is, however, the sleep command resolves it.
sleep 5

touch /home/opc/completed.jupyter

sudo yum install -y git
git clone ${github_repo} repo
if [ "$?" -ne "0" ]
then
  cd repo
  git pull
fi

touch /home/opc/completed.repo
