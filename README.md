# lighthouse-ci-docker

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/pixboost/lighthouse-ci-cli?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/pixboost/lighthouse-ci-cli?style=for-the-badge)
![Travis (.org)](https://img.shields.io/travis/Pixboost/lighthouse-ci-docker?style=for-the-badge)

Docker image for [Lighthouse CI CLI](https://github.com/GoogleChrome/lighthouse-ci)

## Usage

We are using this image in our Bitbucket Pipeline as a step to run LH tests and upload results.

```shell script
docker pull pixboost/lighthouse-ci-cli
```

Example configuration of `lighthouserc.yaml`

**NOTE**: We are using `--no-sandbox --headless` flags to launch Chrome. Given
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

Example of running in Bitbucket Pipelines and copying results to the a GCS bucket:

```yaml
pipelines:
  branches:
    master:
      - step:
          image: pixboost/lighthouse-ci-cli:1-0.3.7
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

## Advantages

* Using alpine node image and trying to keep it as small as possible. Currently - 160MB
* Using tags to pin a specific lhci version
* Travis CI build with healthcheck