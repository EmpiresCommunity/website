# Use a base image
FROM debian:8
MAINTAINER Tama McGlinn

# Install particular dependencies
RUN apt-get update && apt-get install -y \
  git \
  curl
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN stack setup
RUN stack install hakyll

# Set the working directory to /site
WORKDIR /site

# Copy the current directory contents into the container at /site
ADD . /site

# Build the site
RUN ./build

# Deploy the site?
# RUN ./deploy
