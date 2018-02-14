FROM resin/armhf-alpine:latest

ENV DUMP1090_HOST="" DUMP1090_PORT="" FR24_KEY="" 

RUN [ "cross-build-start" ]

WORKDIR /tmp

RUN \
 apk add --no-cache \
 openssl \
 && wget $(wget -qO- https://repo-feed.flightradar24.com/fr24feed_versions.json | egrep _armhf.tgz | grep -v obj | awk -F\" '{print $4}') \
 && tar xvzf *.tgz --strip=1 \
 && apk del openssl \
 && cp fr24feed /usr/bin/ \
 && rm -rf \
       /tmp/*

RUN [ "cross-build-end" ] 

EXPOSE 8754

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/fr24feed", "--fr24key=$FR24_KEY", "--receiver=beast-tcp", "--logmode=1", "--host=$DUMP1090_HOST:$DUMP1090_PORT", "--logpath=/var/log", "--mlat=yes", "--mlat-without-gps=yes", "--bs=no", "--raw=yes"]
