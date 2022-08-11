FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential apt-transport-https ca-certificates software-properties-common \
    gnupg make git vim tmux htop curl wget gzip zip unzip jq tree ncdu ssh

RUN apt-get install -y nodejs npm python3 python3-pip \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN LC_ALL=C pip3 install --upgrade pip \
 && pip install -U setuptools \
 && pip install awscli pytz boto3 --upgrade --force

RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add - \
 && add-apt-repository 'deb https://apt.corretto.aws stable main' \
  && apt-get update && apt-get install -y java-18-amazon-corretto-jdk

# See https://github.com/sbt/sbt/issues/6614 as to why we can't use apt, and have to use the .deb below
#RUN  echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list \
#  && echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list \
#  && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import \
#  && chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg \
#  && apt-get update && apt-get install sbt

RUN wget https://scala.jfrog.io/artifactory/debian/sbt-1.7.1.deb && apt install ./sbt-1.7.1.deb \
    # run sbt once to actually pre-download and build the sbt bridge
    && cd /tmp && sbt new scala/scala-seed.g8 --name=prewarm && cd prewarm && sbt compile

RUN rm -rf /var/lib/apt/lists/* /tmp/prewarm

COPY resources/.bashrc /root/.bashrc

CMD [ "bash" ]

