FROM node:14.17-alpine3.14

RUN apk add --no-cache chromium
RUN npm install -g @lhci/cli@0.8.1

RUN addgroup lhci \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home /home/lhci \
    --ingroup lhci \
    lhci

USER lhci
WORKDIR /home/lhci

RUN mkdir .lighthouseci
VOLUME ["/home/lhci/.lighthouseci"]
