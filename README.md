# ansible docker image

## Overview

This docker image is built on top of CentOS 7 and includes ansible, bigsuds (f5), and pywinrm packages.  The intent of this container is to enable a user to run ansible without having to configure it on their host system.

## Pre-requisites

You must be running Docker on your system, community edition for servers or the Docker for Mac/Windows.  

## Building the image

Building the container:

```console
docker build --rm -t docker-ansible .
```

## Running the container

You will need your playbooks and inventory files on your host machine for this, then we run the following command to start the playbook:

```console
docker run -it --rm -v $(pwd):/ansible/playbooks --name ansible docker-ansible -i <inventory file> <playbook> -u <username> --ask-vault-pass --ask-su-pass --ask-pass -e "other variables"
```
