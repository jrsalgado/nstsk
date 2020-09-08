FROM ubuntu:bionic



RUN apt update
RUN apt install software-properties-common -y
RUN apt-add-repository --yes --update ppa:ansible/ansible
RUN apt install ansible -y

RUN apt install curl -y

WORKDIR /