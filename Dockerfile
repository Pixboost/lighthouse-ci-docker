FROM node:12.13-alpine3.10

RUN apk add --no-cache chromium
RUN npm install -g @lhci/cli@0.3.7

RUN addgroup lhci \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home /home/lhci \
    --ingroup lhci \
    lhci
USER lhci
WORKDIR /home/lhci
