FROM alpine:3.20.3

LABEL maintainer="Aman Maharjan <mhrznamn068@gmail.com>"

RUN apk --update --no-cache add bash curl jq yq git wget ca-certificates \
    python3 python3-dev openssh-client

RUN rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/*

RUN ln -sf /usr/bin/python3 /usr/bin/python

WORKDIR /app

COPY --chmod=0755 ./docker-entrypoint.sh .

ENTRYPOINT [ "./docker-entrypoint.sh" ]
