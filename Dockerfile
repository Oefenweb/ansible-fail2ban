FROM ubuntu:20.04
MAINTAINER Mischa ter Smitten <mtersmitten@oefenweb.nl>

# python
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y python3-minimal python3-dev curl && \
  apt-get clean
RUN curl -sL https://bootstrap.pypa.io/get-pip.py | python3 -
RUN rm -rf $HOME/.cache

# ansible
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gcc libffi-dev libssl-dev && \
  apt-get clean
RUN pip install ansible==2.10
RUN rm -rf $HOME/.cache

# provision
COPY . /etc/ansible/roles/ansible-role
WORKDIR /etc/ansible/roles/ansible-role
RUN ansible-playbook -i tests/inventory tests/test.yml --connection=local
