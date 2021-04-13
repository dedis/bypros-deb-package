#!/bin/sh

SERVICE=bypros.service

# Inspired from Debian packages (e.g. /var/lib/dpkg/info/openssh-server.postinst)
# In case this system is running systemd, we make systemd reload the unit files
# to pick up changes.
if [ -d /run/systemd/system ] ; then
    systemctl --system daemon-reload >/dev/null || true
fi

if [ -x "/usr/bin/deb-systemd-helper" ]; then
    deb-systemd-helper purge ${SERVICE} >/dev/null
fi
