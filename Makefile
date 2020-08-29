#!/usr/bin/env make

PHONY: all
all: install validate build

.PHONY: install
install: install-base install-aws
	pipenv install --dev
	pipenv run ansible-galaxy collection install -r kali/ansible/requirements.yml

.PHONY: install-base
install-base: install-packer install-terraform

.PHONY: install-terraform
install-terraform:
	if [ ! -f /usr/local/bin/terraform ]; then cd /tmp && wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip && cd /tmp && unzip terraform_0.13.0_linux_amd64.zip && mv /tmp/terraform /usr/local/bin && rm terraform_0.13.0_linux_amd64.zip; fi;

.PHONY: install-aws
install-aws:
	if [ ! -f /usr/local/bin/aws ]; then cd /tmp && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && sudo ./aws/install && rm -rf ./aws/ awscliv2.zip; fi;

.PHONY: install-packer
install-packer:
	if [ ! -f /usr/bin/packer ]; then sudo apt-get update && sudo apt-get install -y packer; fi;

.PHONY: validate
validate:
	pipenv run packer validate kali/kali-ami.json

.PHONY: build
build:
	AWS_PROFILE=$${AWS_PROFILE:-terraform} AWS_MAX_ATTEMPTS=90 AWS_POLL_DELAY_SECONDS=60 pipenv run packer build kali/kali-ami.json

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
	cd kali/terraform && terraform init && terraform plan

.PHONY: provision
provision:
	cd kali/terraform && terraform init && terraform validate && terraform apply | tee /tmp/cloud-hackbox-kali-log
	INSTANCE_ID=$$(cat /tmp/cloud-hackbox-kali-log | grep "kali_id" | awk '{ print $$3 }') && INSTANCE_IP=$$(cat /tmp/cloud-hackbox-kali-log | grep "kali_ip" | awk '{ print $$3 }') && printf "\e[34mWaiting for AWS instance \e[32m$${INSTANCE_IP}\e[34m to be available...\e[0m" && aws ec2 wait instance-running --instance-ids $$INSTANCE_ID && echo " \e[32mDone\e[0m"

.PHONY: destroy
destroy:
	cd kali/terraform && terraform destroy
