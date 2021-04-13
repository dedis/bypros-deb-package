#!/bin/bash

# This file is run before starting the service. It creates the private.toml file
# if not already present. It also checks that the config file is filled.

config_file="/etc/dedis/bypros/bypros.conf"

# load config
if [ ! -f "/etc/dedis/bypros/private.toml" ]
then
    source $config_file

    [ -z "$initial_address" ] && echo "initial_address not set in $config_file" && exit 1
    [ -z "$initial_port" ] && echo "initial_port not set in $config_file" && exit 1
    [ -z "$PROXY_DB_URL" ] && echo "PROXY_DB_URL not set in $config_file" && exit 1

    echo -e "$initial_address:$initial_port\nBypros Conode\n/etc/dedis/bypros/" | /opt/dedis/bypros/bin/bypros-deb setup
fi