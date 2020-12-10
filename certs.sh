#!/usr/bin/env bash

# install certbot-auto if not present
if ! command -v certbot-auto 2>&1 >/dev/null; then
	echo "certbot not installed, installing now" | printy info
	sudo wget https://dl.eff.org/certbot-auto -O /usr/local/bin/certbot-auto
	sudo chmod a+x /usr/local/bin/certbot-auto
fi

# get star and root cert
sudo certbot-auto certonly \
	--server https://acme-v02.api.letsencrypt.org/directory \
	--manual \
	--preferred-challenges dns \
	-m certbot@galenguyer.com \
	--rsa-key-size 4096 \
	--agree-tos \
	-d 'galenguyer.com' \
	-d '*.galenguyer.com'
