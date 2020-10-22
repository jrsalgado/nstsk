# DEFAUL VALUES
bucket_name=terraform-states.nearsoft
# Choose in case you have multiple profiles on your workstation
aws_profile ?= nstask
# Choose the AWS region to use
aws_region ?=  us-east-1
# Switch to different TF image version
tf_versions ?= 0.12.29
# Select platform
platform ?= cloud
# Select application environment (dev, stage, prod)
app_env ?= dev

# Terraform container
TERRAFORM := docker run -i --rm -t \
		-v `pwd`:/terraform/ \
		-v ~/.aws:/root/.aws \
		-w /terraform/platform/$(platform) hashicorp/terraform:$(tf_versions)

# Terraform with sh entrypoint
TERRAFORMBASH := docker run -i --rm -t \
		-v `pwd`:/terraform/ \
		-v ~/.aws:/root/.aws \
		--entrypoint=/bin/sh \
		--env ENVIRONMENT="${app_env}" \
		--env AWS_PROFILE="${aws_profile}" \
		-w /terraform/terraform hashicorp/terraform:$(tf_versions)

# Ansible container
ANSIBLE := docker run --interactive --rm --tty  \
                --volume "${PWD}/platform/stateful-application/ansible:/ansible" \
                --volume ~/.aws:/root/.aws \
                --volume "${PWD}/platform/stateful-application/files/id_rsa_evaluator:/tmp/id_rsa_evaluator:ro" \
                --env ENVIRONMENT="${app_env}" \
                --env AWS_PROFILE="${aws_profile}" \
                --entrypoint /usr/local/bin/ansible-playbook \
                --workdir /ansible \
                terraform-ansible:local \
                site.yml

# Format files
.PHONY: fmt
fmt:
	$(TERRAFORM) fmt --recursive

# Terraform sh
.PHONY: bash
bash:
	$(TERRAFORMBASH)

# Terraform Init
.PHONY: init
init:
	$(TERRAFORM) init \
		-backend-config="key=Task/${app_env}/${platform}" \
		-backend-config="bucket=$(bucket_name)" \
		-backend-config="profile=$(aws_profile)" 

# Terraform plan
.PHONY: plan
plan:
	$(TERRAFORM) plan -var 'aws_profile=$(aws_profile)' -var 'aws_region=${aws_region}' -var 'app_env=${app_env}' -var-file=vars_${app_env}.tfvars

# Terraform apply
.PHONY: apply
apply:
	$(TERRAFORM) apply  -var 'aws_profile=$(aws_profile)' -var 'aws_region=${aws_region}' -var 'app_env=${app_env}' -var-file=vars_${app_env}.tfvars

# Terraform destroy
.PHONY: destroy
destroy:
	$(TERRAFORM) destroy -var 'aws_profile=$(aws_profile)' -var 'aws_region=${aws_region}' -var 'app_env=${app_env}' -var-file=vars_${app_env}.tfvars

# Build Terraform Ansible Docker image
.PHONY: ansible-build
ansible-build:
	docker build -t terraform-ansible:local ./platform/stateful-application

# Provision Wordpress and the MySQL server using ansible
.PHONY: provision-wordpress
provision-wordpress:
	sed "s/AWS_REGION_TO_REPLACE/${aws_region}/g" "${PWD}/platform/stateful-application/ansible/inventory/${app_env}/.inventory_aws_ec2.yml" > "${PWD}/platform/stateful-application/ansible/inventory/${app_env}/inventory_aws_ec2.yml"
	$(ANSIBLE)
