FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
  apt-transport-https \
  apt-utils\
  ca-certificates \
  curl \
  libaio1 \
  wget \
  ssh \
  git \
  iputils-ping \
  jq \
  lsb-release \
  software-properties-common \
  gnupg \
  gnupg-agent \
  less \
  zip \
  unzip \
  build-essential

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

# Update apt and install Python
RUN add-apt-repository ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install --no-install-recommends -qq python3.6 python3.6-distutils python3-pip python3.6-venv python3-dev \
  && ln -sf /usr/bin/python3.6 /usr/bin/python3 \
  && rm -rf /var/lib/apt/lists/*
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8


# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update -y && apt install terraform -y 


#Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb |  bash

#Install gcloud cli
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
     
