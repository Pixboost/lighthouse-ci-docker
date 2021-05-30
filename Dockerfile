FROM node:12.17-alpine3.11

RUN apk add --no-cache chromium
RUN npm install -g @lhci/cli@0.4.2

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
