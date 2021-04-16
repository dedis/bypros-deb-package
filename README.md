# bypros-deb-package
Debian package for the Byzcoin Proxy service.

Creates a new .deb package each time a tag corresponding to the version stored
in "./VERSION" is pushed.

# Installation

Get the package from one of the release, then:

```sh
sudo dpkg -i <PACKAGE>.deb
```

Upon installation, a new systemd service called "bypros" is installed and run.
On a fresh install, the service is not expected to run successfully, as you are
required to first fill the configuration file in /etc/dedis/bypros/bypros.conf.
Once it is filled you can re-run with:

```sh
sudo service bypros start
sudo service bypros status
```

You can check the logs with:

```sh
sudo journalctl --unit=bypros.service -n 100
```