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

# Set TZ to avoid spurious errors from Sphinx (nektos/act#1853)
ENV TZ=UTC

# Install Pythons
RUN apt install -y python3.7 python3.7-dev python3.7-venv
RUN apt install -y python3.8 python3.8-dev python3.8-venv
RUN apt install -y pypy3
RUN apt install -y python3.9 python3.9-dev python3.9-venv python3.9-distutils
RUN apt install -y python3.10 python3.10-dev python3.10-venv
RUN apt install -y python3.11 python3.11-dev python3.11-venv
RUN apt install -y python3.12 python3.12-dev python3.12-venv
RUN apt install -y python3.13 python3.13-dev python3.13-venv
RUN apt install -y python3.13-nogil
RUN apt install -y python3.14 python3.14-dev python3.14-venv
RUN apt install -y python3.14-nogil

# Install Rust (required for dependencies of pip-run)
RUN wget https://sh.rustup.rs -O - | sh -s -- -y
ENV PATH /root/.cargo/bin:$PATH

# Clear the env, restoring default behavior
ENV DEBIAN_FRONTEND=

# Install Python launcher
RUN wget https://github.com/brettcannon/python-launcher/releases/download/v1.0.0/python_launcher-1.0.0-$(uname -p)-unknown-linux-gnu.tar.xz -O - | tar xJ --directory /usr/local --strip-components 1
# Default Python
ENV PY_PYTHON=3.13
# Workaround for pip disallowing system packages
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install Python
RUN ln -s $(which pypy3) /usr/local/bin/pypy
RUN ln -s python3 /usr/local/bin/python
RUN ln -s $(which python${PY_PYTHON}) /usr/local/bin/python3
RUN wget -q https://bootstrap.pypa.io/pip/3.7/get-pip.py -O - | py -3.7
RUN wget -q https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip
RUN py -3.8 /tmp/get-pip
RUN pypy /tmp/get-pip
RUN py -3.9 /tmp/get-pip
RUN py -3.10 /tmp/get-pip
RUN py -3.11 /tmp/get-pip
RUN py -3.12 /tmp/get-pip
RUN py -3.13 /tmp/get-pip
RUN py -3.14 /tmp/get-pip

# Install pip-run
RUN py -3.7 -m pip install --target ~/.local/pip-run pip-run
ENV PATH=/root/.local/pip-run/bin:$PATH
ENV PYTHONPATH=/root/.local/pip-run
RUN sed -i -e 's/#!.*/#!py/' /root/.local/pip-run/bin/pip*

# Install pipx
RUN py -m pip install pipx
ENV PATH /root/.local/bin:$PATH

# Use xonsh as the shell
RUN pipx install xonsh[full]
# --pip-args below workaround for CFFI on Python 3.13
RUN pipx inject --pip-args=--pre xonsh jaraco.xonsh

# Install tox
RUN pipx install tox[virtualenv]

# Set the character set to support UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

CMD ["/root/.local/bin/xonsh"]
