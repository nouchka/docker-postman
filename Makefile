DOCKER_IMAGE=postman
DOCKER_NAMESPACE=nouchka
prefix = /usr/local

.DEFAULT_GOAL := build

build:
	docker build -t $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE) .

run:
	./bin/postman

check:
	docker run --rm -i hadolint/hadolint < Dockerfile

test: build run check

install:
	install bin/$(DOCKER_IMAGE) $(prefix)/bin
