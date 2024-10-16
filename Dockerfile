FROM ubuntu:24.10

# using ADD results in a smaller image size than if we used RUN to install curl/wget
ADD https://download.docker.com/linux/ubuntu/gpg                /etc/apt/keyrings/docker.asc
ADD https://ngrok-agent.s3.amazonaws.com/ngrok.asc              /etc/apt/keyrings/ngrok.asc
ADD https://apt.corretto.aws/corretto.key                       /tmp/corretto-apt.key
ADD https://scala.jfrog.io/artifactory/debian/sbt-1.10.2.deb    /tmp/sbt-latest.deb

# unfortunately, some of the apt-repository setup later requires things like gpg
# so we start with a setup apt-get run
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates software-properties-common gnupg

# so that we can install EVERYTHING with a single RUN command, keeping the image as small as possible
# (at the cost of rebuilding the whole image for minor changes, but hey, think how many apt-get updates we save)
RUN install -m 0755 -d /etc/apt/keyrings  \
    && chmod a+r /etc/apt/keyrings/*.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/ngrok.asc] https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list > /dev/null \
    && apt-key add /tmp/corretto-apt.key && add-apt-repository 'deb https://apt.corretto.aws stable main' \
    #
    # ok, setup done, now it should just be a list of apt-get installs
    && apt-get update && apt-get install -y --no-install-recommends \
    # core
    build-essential gnupg make git curl wget gzip zip unzip vim \
    # useful tools
    tmux htop jq tree ncdu ssh tig ngrok \
    # python
    python3 python3-pip python3-tz python3-boto3 awscli \
    # docker
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    # java
    java-21-amazon-corretto-jdk \
    # node
    nodejs npm \
    # miscellaneous clients \
    redis-tools \
    # now all the custom setup / non-apt installs
    # set python as default
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    # sbt is a manual install (https://github.com/sbt/sbt/issues/6614 as to why we can't use apt)
    && apt install /tmp/sbt-latest.deb \
    # sbt on first run downloads and builds a compiler bridge - do this once in the image
    && cd /tmp && sbt new scala/scala-seed.g8 --name=prewarm && cd prewarm && sbt compile

COPY resources/.bashrc /root/.bashrc

CMD [ "bash" ]

