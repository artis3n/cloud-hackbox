#!/usr/bin/env make

PHONY: all
all: validate
	pipenv run packer build kali/kali-ami.json

.PHONY: validate
validate:
	pipenv run packer validate kali/kali-ami.json

.PHONY: molecule
molecule:
	cd kali/ansible && pipenv run molecule test

.PHONY: lint
lint:
	cd kali/ansible && pipenv run ansible-lint
