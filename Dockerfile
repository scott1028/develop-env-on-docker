FROM ubuntu:16.04
RUN apt-get update --fix-missing && apt-get -y install build-essential curl wget git vim nano python python-dev python-pip iputils-ping
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN useradd scott
