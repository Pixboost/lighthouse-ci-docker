# lighthouse-ci-docker

[![Docker Automated build](https://img.shields.io/docker/automated/pixboost/lighthouse-ci-cli.svg)](https://hub.docker.com/r/pixboost/lighthouse-ci-cli/)
[![Build Status](https://travis-ci.org/Pixboost/lighthouse-ci-docker.svg?branch=master)](https://travis-ci.org/Pixboost/lighthouse-ci-docker)

Docker image for [Lighthouse CI CLI](https://github.com/GoogleChrome/lighthouse-ci)

## Usage

We are using this image in our Bitbucket Pipeline as a step to run LH tests and upload results.

```
docker pull pixboost/lighthouse-ci-cli
```

## Advantages

* Using slim node image and trying to keep it as small as possible. Currently - 55MB
* Using tags to pin a specific lhci version