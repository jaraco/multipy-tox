Docker image providing multipe Python versions (multipy) with tox as
[hosted at Docker Hub](https://hub.docker.com/repository/docker/jaraco/multipy-tox).

Now with support for ARM.

After [configuring buildx support](https://docs.docker.com/build/building/multi-platform/):

```
docker buildx create --name multi
docker buildx use multi
```

Build with `docker buildx build --platform linux/amd64,linux/arm64 -t jaraco/multipy-tox --push .`.
