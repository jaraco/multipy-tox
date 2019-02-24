FROM ubuntu:bionic

RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common
RUN apt-add-repository -y ppa:deadsnakes
RUN apt update
RUN apt install -y python3.7 python3.7-dev python3.7-venv wget
RUN ln -s $(which python3.7) /usr/local/bin/python
RUN python -m ensurepip
RUN python -m pip install -U pip tox pip-run
