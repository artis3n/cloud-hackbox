#!/bin/bash

sed -i 's/%%SET_FQDN_HOSTNAME%%/'"$(hostname -f)"'/' /etc/systemd/system/vncserver@.service
systemctl daemon-reload
