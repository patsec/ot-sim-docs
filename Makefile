SHELL=/bin/bash

UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: serve-docs
serve-docs:
	docker build -t mkdocs .
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs mkdocs

.PHONY: build-docs
build-docs:
	docker build -t mkdocs .
	docker run --rm -it -v ${PWD}:/docs mkdocs build
	sudo chown -R ${UID}:${GID} docs
