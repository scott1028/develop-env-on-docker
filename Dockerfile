FROM ubuntu:16.04
RUN apt-get update
RUN apt-get -y install build-essential curl wget git vim nano
RUN curl -L git.io/nodebrew | perl - setup
RUN echo "export PATH=\$HOME/.nodebrew/current/bin:\$PATH" >> ~/.bashrc
