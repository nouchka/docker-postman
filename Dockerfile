FROM debian:stable-slim
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG VERSION=6.6.1
ARG FILE_SHA256SUM=397172c0c9533625a9d7a9725a9cd8d3a2ff5f56306f408c2b223acc86302a49
ENV FILE_URL https://dl.pstmn.io/download/version/${VERSION}/linux64

WORKDIR /tmp
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install \
		wget=* \
		tar=* \
		ca-certificates=* \
		libcanberra-gtk-module=* \
		libx11-xcb-dev=* \
		libxtst-dev=* \
		libxss-dev=* \
		libgconf2-dev=* \
		libnss3=* && \
	wget -qO- "${FILE_URL}" > /tmp/archive.tgz && \
	sha256sum /tmp/archive.tgz && \
	echo "${FILE_SHA256SUM}  /tmp/archive.tgz"| sha256sum -c - && \
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

