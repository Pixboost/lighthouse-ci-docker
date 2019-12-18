FROM node:12.13-alpine3.10

RUN useradd -m -s /bin/bash lhci

RUN apk add --no-cache chromium
RUN npm install -g @lhci/cli@0.3.7

USER lhci
