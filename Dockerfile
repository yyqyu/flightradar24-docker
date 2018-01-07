FROM resin/raspberrypi3-debian:jessie

ENV DUMP1090_HOST="" DUMP1090_PORT="" FR24_KEY="" 

RUN [ "cross-build-start" ]

WORKDIR /tmp

RUN \
 gpg --keyserver pgp.mit.edu --recv-keys 40C430F5 \
 && gpg --armor --export 40C430F5 | apt-key add -

# Add APT repository to the config file, removing older entries if exist

RUN \
 echo 'deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable' >> /etc/apt/sources.list.d/fr24.list

RUN \
 apt-get update -qy \
 && apt-get install --no-install-recommends -qy \
    fr24feed \
 && apt-get clean \
 && rm -rf \
    /tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

RUN [ "cross-build-end" ] 

EXPOSE 8754

WORKDIR /root

COPY ./start.sh start.sh		
RUN chmod +x start.sh

ENTRYPOINT ["/root/start.sh"]
