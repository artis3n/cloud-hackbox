#!/usr/bin/env make

PHONY: all
all: install validate build

.PHONY: install
install:
	pipenv install --dev

.PHONY: validate
validate:
	pipenv run packer validate kali/kali-ami.json

.PHONY: build
build:
	AWS_MAX_ATTEMPTS=90 AWS_POLL_DELAY_SECONDS=60 pipenv run packer build kali/kali-ami.json

.PHONY: molecule
molecule:
	cd kali/ansible && pipenv run molecule test

.PHONY: lint
lint:
	cd kali/ansible && pipenv run ansible-lint
