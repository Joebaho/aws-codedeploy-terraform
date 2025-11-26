#!/bin/bash
echo "BeforeInstall: Stopping web server"
sudo systemctl stop httpd || true