# lighthouse-ci-docker

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/pixboost/lighthouse-ci-cli)](https://hub.docker.com/r/pixboost/lighthouse-ci-cli/)
[![Docker Pulls](https://img.shields.io/docker/pulls/pixboost/lighthouse-ci-cli)](https://hub.docker.com/r/pixboost/lighthouse-ci-cli/)
[![Build](https://github.com/Pixboost/lighthouse-ci-docker/actions/workflows/build.yml/badge.svg)](https://github.com/Pixboost/lighthouse-ci-docker/actions/workflows/build.yml)

Docker image for [Lighthouse CI CLI](https://github.com/GoogleChrome/lighthouse-ci)

## Advantages comparing to similar images

* Using alpine node image as a base and trying to keep it as small as possible. Currently - 160MB
* Using tags to pin a specific lhci version
* GitHub Actions build with healthcheck
* Not using `root` user in a container

## Usage

### Locally

You could use [example config file](example/lighthouserc.example.yaml) from this repo to
run LightHouse on any website. Just replace https://pixboost.com from in the configuration
and run the command below:

```
docker run -it --rm -v $(pwd)/example:/home/lhci/example \
--user=$(id -u):$(id -g) \
-v $(pwd)/.lighthouseci:/home/lhci/.lighthouseci \
pixboost/lighthouse-ci-cli lhci --config ./example/lighthouserc.example.yaml autorun
```

You'll find the results in `.lighthouseci` folder.

### In CI Pipeline
We are using this image in our Bitbucket Pipeline as a step to run LH tests and then upload results to 
Google Cloud Storage.

Example configuration of `lighthouserc.yaml`

**NOTE**: We are using `--no-sandbox --headless` flags to launch Chromium. Given
we are not running Chrome as root user `--no-sandbox` shouldn't be a concern.

```yaml
ci:
    collect:
        staticDistDir: ./
        additive: false
        url:
        - index.html
        settings:
            chrome-flags: "--no-sandbox --headless"
            throttling-method: simulate
            # https://github.com/GoogleChrome/lighthouse/blob/8f500e00243e07ef0a80b39334bedcc8ddc8d3d0/lighthouse-core/config/constants.js#L19-L26
            throttling:
                throughputKbps: 1638
                uploadThroughputKbps: 675
                cpuSlowdownMultiplier: 4
    assert:
        preset: lighthouse:no-pwa

```

Example of running in Bitbucket Pipelines and copying results to a GCS bucket:

```yaml
pipelines:
  branches:
    master:
      - step:
          image: pixboost/lighthouse-ci-cli:1.0.0-0.3.7
          name: Lighthouse
          script:
            - echo "Everything is CI"
            - lhci autorun || true
          artifacts:
            - .lighthouseci/**
      - step:
          image: google/cloud-sdk:273.0.0-slim
          script:
            - echo "Everything is awesome!"
            - gcloud auth activate-service-account --key-file ~/sa.json
            - mv .lighthouseci .lighthouse-$BITBUCKET_BUILD_NUMBER
            - gsutil cp -a public-read -r ./.lighthouse-$BITBUCKET_BUILD_NUMBER gs://<YOUR_BUCKET_WITH_RESULTS>
```

## Versioning

We are using semver with `lhci` version as a suffix. An example: `1.0.0-0.3.7` where
`1.0.0` is a version of the image and `0.3.7` is a version of `lhci`.  
