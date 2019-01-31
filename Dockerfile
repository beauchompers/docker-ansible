# docker container for running ansible
# includes f5 and pywinrm modules for managing F5 and windows machines.

FROM centos:7

ENV REFRESHED_AT 2019-01-01

ENV container docker

# Install OS pre-requisites
RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install unzip gcc curl openssl-devel openssh-client git python python-pip python-crypto python-ldap python-devel sshpass; yum clean all

# Install/Update Python modules including F5 (bigsuds) and Windows (pywinrm)
RUN pip install --upgrade pip requests ansible
RUN easy_install -U setuptools
RUN pip install --upgrade bigsuds pywinrm

# Remove packages to save space
RUN yum -y remove epel-release gcc openssl-devel

# Prepare Ansible environment
RUN mkdir /etc/ansible/ /ansible /etc/ansible/roles/
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /etc/ansible/roles
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]

# Sample command to build image with this Dockerfile:
#docker build --rm -t docker-ansible .

# Check out playbooks and inventories, then run the following command to start the playbook
# docker run -it --rm -v <local directory to playbook>:/ansible/playbooks --name ansible docker-ansible -i <inventory file> <playbook> -u username --ask-pass --ask-sudo-pass -e "other environment variables" -vvv
# for example:
# docker run -it --rm -v $(pwd):/ansible/playbooks  --name ansible docker-ansible  -i inventories/demo demo.yml -u username --ask-pass --ask-sudo-pass -vvv
