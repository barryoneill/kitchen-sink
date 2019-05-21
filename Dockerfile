FROM ubuntu:19.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    # --- build tools --- \
    build-essential apt-transport-https ca-certificates software-properties-common \
    gnupg make  \
    # --- shell utils ---
    ssh git vim tmux htop curl wget nodejs npm \
    gzip zip unzip jq tree ncdu \
    # --- dev tooling --- \
    python3-pip openjdk-11-jdk \
    # --- remove cruft that bloats image size --- \
    && rm -rf /var/lib/apt/lists/*

RUN LC_ALL=C pip3 install --upgrade pip \
 && pip install -U setuptools \
 && pip install awscli pytz boto3 --upgrade --force

COPY resources/.bashrc /root/.bashrc

CMD [ "bash" ]

