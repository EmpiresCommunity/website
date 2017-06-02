# Use an official Python runtime as a base image
FROM ubuntu:12.04

# Set the working directory to /site
WORKDIR /site

# Copy the current directory contents into the container at /app
ADD . /site

# Run app.py when the container launches
# CMD ["python", "app.py"]
