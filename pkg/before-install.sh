#!/bin/sh

config_file="/etc/dedis/bypros/bypros.conf"

# create bypros group
if ! getent group bypros >/dev/null; then
    groupadd -r bypros
fi

# create bypros user
if ! getent passwd bypros >/dev/null; then
    useradd -M -r -g bypros -d /var/lib/dedis/bypros -s /usr/sbin/nologin -c "Bypros service" bypros
fi