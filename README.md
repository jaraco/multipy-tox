Docker image providing multipe Python versions (multipy) with tox as
[hosted at Docker Hub](https://hub.docker.com/repository/docker/jaraco/multipy-tox).

Now with support for ARM.

After [configuring buildx support](https://cloudolife.com/2022/03/05/Infrastructure-as-Code-IaC/Container/Docker/Docker-buildx-support-multiple-architectures-images/), build with `docker buildx build --platform linux/amd64,linux/arm64 -t jaraco/multipy-tox --push .`.
