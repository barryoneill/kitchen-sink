# kitchen-sink

[![Build Docker Image](https://github.com/barryoneill/kitchen-sink/actions/workflows/ci.yaml/badge.svg)](https://github.com/barryoneill/kitchen-sink/actions/workflows/ci.yaml)

Of limited value to anyone but me, this is a simple ubuntu image that I use when I want to try out something without polluting my local machine.

See the [Dockerfile](Dockerfile) for the contents, but right now it's a very basic image that contains CLI tooling, and a few SDKs.

To use it, run

```$bash
docker run -it barryoneill/kitchen-sink
```

Visit the [dockerhub page](https://hub.docker.com/r/barryoneill/kitchen-sink/tags) for the available tags.

