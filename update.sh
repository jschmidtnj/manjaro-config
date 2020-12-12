#!/bin/bash

set -e

yay -Syu

sudo sed -i 's/=plex/=joshua/' /usr/lib/systemd/system/plexmediaserver.service
sudo systemctl daemon-reload
sudo systemctl restart plexmediaserver

