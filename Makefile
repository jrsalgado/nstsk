# DEFAUL VALUES
bucket_name=nstask
# Choose in case you have multiple profiles on your workstation
aws_profile ?= nstask
# Switch to different TF image version
tf_versions ?= 0.12.21
# Select platform
platform ?= cloud
# Select application environment (dev, stage, prod)
app_env ?= dev

# Terraform container
TERRAFORM := docker run -i -t \
		-v `pwd`:/terraform/ \
		-v ~/.aws:/root/.aws \
		-w /terraform/platform/$(platform) hashicorp/terraform:$(tf_versions)

# Terraform with bash entrypoint
TERRAFORMBASH := docker run -i -t \
		-v `pwd`:/terraform/ \
		-v ~/.aws:/root/.aws \
		--entrypoint=/bin/sh \
		-w /terraform/terraform hashicorp/terraform:$(tf_versions)

# Format files
.PHONY: fmt
fmt:
	$(TERRAFORM) fmt --recursive

# Terraform Bash
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
	$(TERRAFORM) plan -var 'aws_profile=$(aws_profile)' -var 'app_env=${app_env}' -var-file=vars_${app_env}.tfvars

# Terraform apply
.PHONY: apply
apply:
	$(TERRAFORM) apply -var 'aws_profile=$(aws_profile)' -var 'app_env=${app_env}' -var-file=vars_${app_env}.tfvars

# Terraform destroy
.PHONY: destroy
destroy:
	$(TERRAFORM) destroy -var 'aws_profile=$(aws_profile)' -var 'app_env=${app_env}' -var-file=vars_${app_env}.tfvars
