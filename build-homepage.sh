#!/bin/bash

# get source for page
git clone https://github.com/galenguyer/galenguyer.com && cd galenguyer.com
# download and unpack zola
wget -q https://github.com/getzola/zola/releases/download/v0.12.2/zola-v0.12.2-x86_64-unknown-linux-gnu.tar.gz
tar xzf zola-v0.12.2-x86_64-unknown-linux-gnu.tar.gz
# build site
./zola build
# set permissions
chown www-data:www-data public -R
# sync edge nodes
cd ../ansible
ansible-playbook homepage.yaml
# copy files to /var/www/galenguyer.com
cd ..
rm -r /var/www/galenguyer.com
mv galenguyer.com/public /var/www/galenguyer.com
# destroy build directory
rm -r galenguyer.com
