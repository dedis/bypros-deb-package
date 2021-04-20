# bypros-deb-package
Debian package for the Byzcoin Proxy service.

Creates a new .deb package each time a new version is pushed in "./VERSION".

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

# Configure Bypros

```sh
sudo vim /etc/dedis/bypros/bypros.conf
```

here is an example:

```sh
initial_address=localhost
initial_port=7070
PROXY_DB_URL=postgres://bypros:docker@localhost:5432/bypros
PROXY_DB_URL_RO=postgres://proxy:1234@localhost:5432/bypros
CONODE_SERVICE_PATH=/etc/dedis/bypros
```

# Install Postgres with Docker

The Bypros service needs to connect to an SQL instance.

## Install with Docker

```sh
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
docker --version
```

## Create a Dockerfile

```sh
vim Dockerfile
```

with the following content:

```dockerfile
FROM postgres:13

COPY schema.sql docker-entrypoint-initdb.d/

# change with your own
ENV POSTGRES_PASSWORD=docker
ENV POSTGRES_USER=bypros
ENV POSTGRES_DB=bypros
```

## Download the schema, build the image, and run the container

```sh
wget https://raw.githubusercontent.com/dedis/cothority/master/bypros/storage/sqlstore/schema/schema.sql

sudo docker build .

mkdir postgres

sudo docker run -p 5432:5432 -v ${PWD}/postgres:/var/lib/postgresql/data -d a74a2bd2c6cc
```

# Use nginx to proxy the service

In this setting we use a "password" in the url for the admin actions and make
the "Query" action public:

```sh
	location /conode/ByzcoinProxy/Query {
		proxy_http_version 1.1;

		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "Upgrade";
		proxy_set_header Host $host;
		proxy_pass "http://localhost:7071/ByzcoinProxy/Query";
	}

	location ~^/conode/(.*)/the_password_to_use$ {
		proxy_http_version 1.1;

		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "Upgrade";
		proxy_set_header Host $host;
		proxy_pass "http://localhost:7071/$1";
	}
```