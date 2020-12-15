#!/bin/bash

set -e

yay -Syu

sleep 5 # sleep for a few seconds before running the rest

echo "updating plex with new settings"

sudo sed -i 's/=plex/=joshua/' /usr/lib/systemd/system/plexmediaserver.service
sleep 1
sudo systemctl daemon-reload
sudo systemctl restart plexmediaserver

