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

Example of using in Bitbucket Pipelines and copying results to the a GCS bucket:

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