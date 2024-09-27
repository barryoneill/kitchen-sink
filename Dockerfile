FROM ubuntu:24.10

# core setup
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential apt-transport-https ca-certificates software-properties-common \
    gnupg make git vim tmux htop curl wget gzip zip unzip jq tree ncdu ssh tig

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
      apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN apt-get install -y nodejs npm python3 python3-pip \
    awscli python3-tz python3-boto3 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add - \
  && add-apt-repository 'deb https://apt.corretto.aws stable main' \
  && apt-get update && apt-get install -y java-21-amazon-corretto-jdk

## See https://github.com/sbt/sbt/issues/6614 as to why we can't use apt
RUN wget https://scala.jfrog.io/artifactory/debian/sbt-1.10.2.deb && apt install ./sbt-1.10.2.deb \
    # run sbt once to actually pre-download and build the sbt bridge
    && cd /tmp && sbt new scala/scala-seed.g8 --name=prewarm && cd prewarm && sbt compile

RUN curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && apt update && apt install ngrok

RUN rm -rf /var/lib/apt/lists/* /tmp/prewarm

COPY resources/.bashrc /root/.bashrc

CMD [ "bash" ]

