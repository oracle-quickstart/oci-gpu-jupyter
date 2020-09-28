#!/bin/bash

#
# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# The Universal Permissive License (UPL), Version 1.0
#

#sudo yum update -y

# Set up certbot for SSL -- if you have a real domain
# LetsEncrypt does not work with IP addresses only

#wget https://dl.eff.org/certbot-auto
#sudo mv certbot-auto /usr/local/bin/certbot-auto
#sudo chown root /usr/local/bin/certbot-auto
#sudo chmod 0755 /usr/local/bin/certbot-auto

#sudo /usr/local/bin/certbot-auto certonly --standalone

# Update crontab and renew certs
#echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/local/bin/certbot-auto renew -q" | sudo tee -a /etc/crontab > /dev/null
