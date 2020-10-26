FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV TERRAFORM_VERSION 0.12.29

RUN apt-get update -y && \
    apt-get install --no-install-recommends --yes \
      apt-utils \
      python3.8 \
      python3-pip \
      unzip \
      vim \
      jq \
      less \
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
    curl -sO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/ && \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

WORKDIR /ansible/
