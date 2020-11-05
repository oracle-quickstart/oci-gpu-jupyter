#!/bin/bash 

# Redirect stdout & stderr to syslog 

#  Get the base dir that the script is running in. This works for everything
#  except if the script is symlinked, which should not be the case running in
#  terraform
DIR="$( cd "$( dirname "$${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Send output to /var/log/messages
exec 1> >(logger -s -t $0) 2>&1

# Use this command to debug the script
set -x

cd /home/opc

source ~/mlenv/bin/activate
touch /home/opc/completed.mlenv

# sudo yum upgrade

# Java is alread installed, however if JDK is needed, use:
# sudo yum install -y openjdk-8-jre-headless

# Ensure Java can be found
export JAVA_HOME=/usr/java/jre1.8.0_251-amd64

# Install sparkNLP -- versions are important
pip install --ignore-installed -q pyspark==2.4.4
pip install --ignore-installed -q spark-nlp

# Install Oracle client libraries
sudo yum install -y oracle-instantclient18.3-basic.x86_64

# Register mlenv with Python Notebooks as a kernel
pip install ipykernel
python -m ipykernel install --user --name=mlenv

# Misc. packages 
pip install jupyter-sql
pip install ipython-sql
pip install cx_oracle

touch /home/opc/completed.pip.install

export ORACLE_HOME=/usr/lib/oracle/18.3/client64
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/bin/:$ORACLE_HOME/lib/

DOWNLOAD_DIR=~/download
mkdir -p $DOWNLOAD_DIR
# Install scala

cd $DOWNLOAD_DIR
wget http://www.scala-lang.org/files/archive/scala-2.10.1.tgz
tar xvf scala-2.10.1.tgz
sudo mv scala-2.10.1 /usr/lib
sudo ln -s /usr/lib/scala-2.10.1 /usr/lib/scala
export PATH=$PATH:/usr/lib/scala/bin
touch /home/opc/scala.install

# Go get Spark with a specific hadoop version
cd $DOWNLOAD_DIR
wget https://archive.apache.org/dist/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
tar -xzf spark-2.4.5-bin-hadoop2.7.tgz
export SPARK_HOME=$DOWNLOAD_DIR/spark-2.4.5-bin-hadoop2.7
export PATH=$PATH:$SPARK_HOME/bin
touch /home/opc/spark.install

# Get hadoop
cd ~/download
wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz
tar -xzf hadoop-2.7.3.tar.gz

# add environment variables
export HADOOP_HOME=$DOWNLOAD_DIR/hadoop-2.7.3
export HADOOP_CONF_DIR=$DOWNLOAD_DIR/hadoop-2.7.3/etc/hadoop
export HADOOP_MAPRED_HOME=$DOWNLOAD_DIR/hadoop-2.7.3
export HADOOP_COMMON_HOME=$DOWNLOAD_DIR/hadoop-2.7.3
export HADOOP_HDFS_HOME=$DOWNLOAD_DIR/hadoop-2.7.3
export YARN_HOME=$DOWNLOAD_DIR/hadoop-2.7.3
export PATH=$PATH:$DOWNLOAD_DIR/hadoop-2.7.3/bin
touch /home/opc/hadoop.install

# Set the password for Jupyter Notebooks
p_hash=$(python3 -c "from notebook.auth import passwd; print(passwd('${jupyter_password}'))")

# Start the notebooks with nohup. Needed so the notebooks don't
# exit when this script exits.
cd /home/opc

cmd="jupyter notebook --ip=0.0.0.0 --port=8080 --NotebookApp.password=$p_hash ";
nohup $cmd > /home/opc/notebook.log 2>&1 &

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
