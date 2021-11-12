FROM ubuntu:focal

# Disable PIP version warnings; it'll never get better.
ENV PIP_NO_PYTHON_VERSION_WARNING=1

# Prefer PEP517 for builds
ENV PIP_USE_PEP517=1

# Disable installing Setuptools by default
ENV PIP_NO_SETUPTOOLS=1

RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common
RUN apt-add-repository -y ppa:deadsnakes
RUN apt update
RUN apt install -y build-essential wget git

# Install Pythons
RUN apt install -y python3.5-dev python3.5-venv python2.7
RUN apt install -y python3.6 python3.6-dev python3.6-venv
RUN apt install -y python3-distutils
RUN apt install -y python3.7 python3.7-dev python3.7-venv
RUN apt install -y python3.8 python3.8-dev python3.8-venv
RUN apt install -y pypy3
RUN apt install -y python3.9 python3.9-dev python3.9-venv python3.9-distutils
RUN apt install -y python3.10 python3.10-dev python3.10-venv

# Install Python launcher
RUN wget https://github.com/brettcannon/python-launcher/releases/download/v1.0.0/python_launcher-1.0.0-x86_64-unknown-linux-gnu.tar.xz -O - | tar xJ --directory /usr/local --strip-components 1

RUN ln -s $(which pypy3) /usr/local/bin/pypy
RUN ln -s $(which python3.10) /usr/local/bin/python
RUN ln -s $(which python3.10) /usr/local/bin/python3
RUN wget -q https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /tmp/get-pip
RUN py -2 /tmp/get-pip
RUN py -2 -m pip install -U pip-run
RUN py -3.5 /tmp/get-pip
RUN py -3.5 -m pip install -U pip-run
RUN wget -q https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip
RUN py -3.6 /tmp/get-pip
RUN py -3.6 -m pip install -U pip-run
RUN py -3.7 -m ensurepip
RUN py -3.7 -m pip install -U pip pip-run
RUN py -3.8 /tmp/get-pip
RUN py -3.8 -m pip install -U pip pip-run
RUN pypy /tmp/get-pip
RUN pypy -m pip install -U pip-run
RUN py -3.9 /tmp/get-pip
RUN py -3.9 -m pip install -U pip pip-run
RUN py -3.10 /tmp/get-pip
RUN py -3.10 -m pip install -U pip pip-run pipx

# Make pipx installs executable
ENV PATH /root/.local/bin:$PATH

# Use xonsh as the shell
RUN pipx install xonsh[full]
RUN touch ~/.xonshrc

# Install tox
RUN pipx install tox

# Set the character set to support UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
