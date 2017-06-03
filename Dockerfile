# Use an official Python runtime as a base image
FROM ubuntu:12.04

# Set the working directory to /site
WORKDIR /site

# Copy the current directory contents into the container at /site
ADD . /site

# Build site locally
CMD ["make"]
