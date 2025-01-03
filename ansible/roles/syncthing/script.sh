#!/usr/bin/env bash
set eux

# Add the release PGP keys:
sudo mkdir -p /etc/apt/keyrings
sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
# Add the "candidate" channel to your APT sources:
echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

# Enable and start user service 
systemctl enable syncthing@lukcic.service
systemctl start syncthing@lukcic.service

# Edit config to enable bind addresses
cd /home/lukcic/.local/state/syncthing

sed -i 's/127.0.0.1:8384/0.0.0.0:8384/g' config.xml

# Restart service
systemctl restart syncthing@lukcic.service