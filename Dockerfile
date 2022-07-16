FROM debian:stable-slim

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG VERSION=9
ENV FILE_URL https://dl.pstmn.io/download/latest/linux64

WORKDIR /tmp
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install \
		wget=* \
		tar=* \
		fonts-takao-mincho=* \
		ca-certificates=* \
		libcanberra-gtk-module=* \
		libx11-xcb-dev=* \
		libxtst-dev=* \
		libxss-dev=* \
		libgconf2-dev=* \
		libgbm-dev=* \
		libxshmfence1=* \
		libatk-bridge2.0-0=* \
		libdrm2=* \
		libgtk-3-0=* \
##		libglu1=* \
		libnss3=* && \
	wget -qO- "${FILE_URL}" > /tmp/archive.tgz && \
	sha256sum /tmp/archive.tgz && \
	tar xzf /tmp/archive.tgz -C / && \
	chmod +x /Postman/Postman && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	export uid=${PUID} gid=${PGID} && \
	mkdir -p /home/developer/.config/Postman && \
	mkdir -p /home/developer/postman && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown "${uid}:${gid}" -R /home/developer

VOLUME /home/developer/postman /home/developer/.config/Postman
WORKDIR /home/developer/postman

USER developer
ENTRYPOINT [ "/Postman/Postman" ]

