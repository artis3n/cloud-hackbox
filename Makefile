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
lint: lint-ans lint-tf

.PHONY: lint-ans
lint-ans:
	cd kali/ansible && pipenv run ansible-lint

.PHONY: lint-tf
lint-tf:
	cd kali/terraform && terraform validate

.PHONY: plan
plan:
	cd kali/terraform && terraform plan -var-file="input.tfvars"

.PHONY: provision
provision:
	cd kali/terraform && terraform init && terraform validate && terraform plan -out tfplan -var-file="input.tfvars" && terraform apply -var-file="input.tfvars" tfplan
	rm tfplan
