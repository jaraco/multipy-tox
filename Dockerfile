FROM ubuntu:noble

# Disable PIP version warnings; it'll never get better.
ENV PIP_NO_PYTHON_VERSION_WARNING=1

# Disable "root user" warning
ENV PIP_ROOT_USER_ACTION=ignore

# Disable installing Setuptools by default
ENV PIP_NO_SETUPTOOLS=1

RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common
RUN apt-add-repository -y ppa:deadsnakes
RUN apt update
RUN apt install -y build-essential wget git

# Disable interactive on the installs below
ENV DEBIAN_FRONTEND=noninteractive

# Install Pythons
RUN apt install -y python3.7 python3.7-dev python3.7-venv
RUN apt install -y python3.8 python3.8-dev python3.8-venv
RUN apt install -y pypy3
RUN apt install -y python3.9 python3.9-dev python3.9-venv python3.9-distutils
RUN apt install -y python3.10 python3.10-dev python3.10-venv
RUN apt install -y python3.11 python3.11-dev python3.11-venv
RUN apt install -y python3.12 python3.12-dev python3.12-venv
# 3.13 temporarily disabled until available
# https://github.com/deadsnakes/issues/issues/282#issuecomment-2081698420
# RUN apt install -y python3.13 python3.13-dev python3.13-venv

# Install Rust (required for dependencies of pip-run)
RUN wget https://sh.rustup.rs -O - | sh -s -- -y
ENV PATH /root/.cargo/bin:$PATH

# Clear the env, restoring default behavior
ENV DEBIAN_FRONTEND=

# Install Python launcher
RUN wget https://github.com/brettcannon/python-launcher/releases/download/v1.0.0/python_launcher-1.0.0-$(uname -p)-unknown-linux-gnu.tar.xz -O - | tar xJ --directory /usr/local --strip-components 1
# Default Python
ENV PY_PYTHON=3.12
# Workaround for pip disallowing system packages
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN ln -s $(which pypy3) /usr/local/bin/pypy
RUN ln -s python3 /usr/local/bin/python
RUN ln -s $(which python${PY_PYTHON}) /usr/local/bin/python3
RUN wget -q https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip
RUN py -3.7 /tmp/get-pip
RUN py -3.7 -m pip install pip-run
RUN py -3.8 /tmp/get-pip
RUN py -3.8 -m pip install pip-run
RUN pypy /tmp/get-pip
RUN pypy -m pip install pip-run
RUN py -3.9 /tmp/get-pip
RUN py -3.9 -m pip install pip-run
RUN py -3.10 /tmp/get-pip
RUN py -3.10 -m pip install pip-run
RUN py -3.11 /tmp/get-pip
RUN py -3.11 -m pip install pip-run
RUN py -3.12 /tmp/get-pip
RUN py -3.12 -m pip install pip-run
# RUN py -3.13 /tmp/get-pip
# RUN py -3.13 -m pip install pip-run

RUN py -m pip install pipx

# Make pipx installs executable
ENV PATH /root/.local/bin:$PATH

# Use xonsh as the shell
RUN pipx install xonsh[full]
RUN pipx inject xonsh jaraco.xonsh

# Install tox
RUN pipx install tox[virtualenv]

# Set the character set to support UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

CMD ["/root/.local/bin/xonsh"]
