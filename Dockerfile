FROM ubuntu:bionic

RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common
RUN apt-add-repository -y ppa:deadsnakes
RUN apt update
RUN apt install -y python3.8 python3.8-dev python3.8-venv python3.7 python3.7-dev python3.7-venv python3.6 python3.6-dev python3.6-venv python2.7 wget git
RUN ln -s $(which python3.8) /usr/local/bin/python
RUN python -m ensurepip
RUN python -m pip install -U pip tox tox-pip-version tox-venv pip-run
RUN python3.7 -m ensurepip
RUN python3.7 -m pip install -U pip pip-run
RUN wget -q https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py
RUN python3.6 -m pip install -U pip-run
RUN python2.7 get-pip.py
RUN python2.7 -m pip install -U pip-run
