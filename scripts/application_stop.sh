#!/bin/bash
echo "ApplicationStop: Stopping web server"
sudo systemctl stop httpd || true