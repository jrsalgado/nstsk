# Installs AWS CLI, Ansible, Terraform and various troubleshooting tools

FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends --yes \
      apt-utils \
      python3.8 \
      python3-pip \
      unzip \
      vim \
      jq \
      iputils-ping \
      dnsutils \
      openssh-client \
      net-tools \
      curl && \
    pip3 install --upgrade \
      awscli \
      ansible \
      pymysql \
      boto3 \
      botocore \
      ansible-lint && \
    curl -sO https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip && \
    unzip terraform_0.12.21_linux_amd64.zip -d  /usr/local/bin/ && \
    rm terraform_0.12.21_linux_amd64.zip
 
WORKDIR /
