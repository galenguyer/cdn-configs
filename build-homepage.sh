#!/bin/bash

git clone https://github.com/galenguyer/galenguyer.com
cd galenguyer.com
wget https://github.com/getzola/zola/releases/download/v0.12.2/zola-v0.12.2-x86_64-unknown-linux-gnu.tar.gz
tar xzvf zola-v0.12.2-x86_64-unknown-linux-gnu.tar.gz
./zola build
chown www-data:www-data public -Rv
cd ../ansible
ansible-playbook homepage.yaml
cd ..
rm -r galenguyer.com
