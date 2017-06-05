from ivotron/hakyll

RUN apt-get update && apt-get install -y \
    curl

RUN curl -sSL https://get.haskellstack.org/ | sh
ENV PATH "$PATH:/root/.local/bin"
copy stack.yaml /root/src/
copy empires.cabal /root/src/
RUN stack setup
RUN stack install hakyll

copy site.hs /root/src/
RUN stack build
copy . /root/src/

workdir /root/src
run /root/src/buildsite
