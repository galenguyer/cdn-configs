#!/bin/bash
cd ./terraform
terraform apply --auto--aprove
cd ../ansible
ansible-playbook all.yaml
