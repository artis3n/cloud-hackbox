#!/usr/bin/env make

PHONY: all
all: install lint build

.PHONY: install
install:
	pipenv install --dev
	pipenv run ansible-galaxy install --role-file kali/ansible/requirements.yml
	pipenv run pre-commit install --install-hooks
	cd kali/terraform && terraform init

.PHONY: update
update:
	pipenv update --dev
	pipenv run pre-commit autoupdate
	pipenv run ansible-galaxy install --role-file kali/ansible/requirements.yml

.PHONY: install-base
install-base: install-packer install-terraform install-aws

.PHONY: install-terraform
install-terraform:
	if [ ! -f /usr/bin/terraform ]; then sudo apt-get update && sudo apt-get install -y terraform; fi;

.PHONY: install-aws
install-aws:
	if [ ! -f /usr/local/bin/aws ]; then cd /tmp && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && sudo ./aws/install && rm -rf ./aws/ awscliv2.zip; fi;

.PHONY: install-packer
install-packer:
	if [ ! -f /usr/bin/packer ]; then sudo apt-get update && sudo apt-get install -y packer; fi;

.PHONY: validate
validate:
	pipenv run packer validate kali/

.PHONY: build
build:
	AWS_MAX_ATTEMPTS=90 AWS_POLL_DELAY_SECONDS=60 aws-vault exec --duration=2h terraform -- pipenv run packer build kali/

.PHONY: molecule
molecule:
	cd kali/ansible && pipenv run molecule test

.PHONY: lint
lint: lint-ans lint-tf validate

.PHONY: lint-ans
lint-ans:
	cd kali/ansible && pipenv run ansible-lint

.PHONY: lint-tf
lint-tf:
	cd kali/terraform && terraform validate

.PHONY: plan
plan:
	cd kali/terraform && terraform init && terraform plan

.PHONY: provision
provision:
	cd kali/terraform && terraform init && terraform validate && terraform apply | tee /tmp/cloud-hackbox-kali.log
	INSTANCE_ID=$$(cat /tmp/cloud-hackbox-kali.log | grep "kali_id" | awk 'FNR==2{ print substr($$3, 2, length($$3)-2) }') && INSTANCE_IP=$$(cat /tmp/cloud-hackbox-kali.log | grep "kali_ip" | awk 'FNR==2{ print substr($$3, 2, length($$3)-2) }') && printf "\e[34mWaiting for AWS instance \e[32m$${INSTANCE_IP}\e[34m ($${INSTANCE_ID}) to be available...\e[0m" && aws-vault exec --region=$${AWS_REGION:us-east-1} terraform -- aws ec2 wait instance-status-ok --instance-ids $$INSTANCE_ID && printf " \e[32mDone\e[0m\n"

.PHONY: destroy
destroy:
	cd kali/terraform && terraform destroy
