from ivotron/hakyll

RUN apt-get update && apt-get install -y \
    curl

RUN curl -sSL https://get.haskellstack.org/ | sh
ENV PATH "$PATH:/root/.local/bin"
RUN stack setup
RUN stack install hakyll

copy . /root/src/

workdir /root/src
entrypoint /root/src/build
