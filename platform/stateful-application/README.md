make apply aws_profile=nstask 

make init aws_profile=nstask app_env=junior-h platform=stateful-application


make plan aws_profile=nstask app_env=junior-h platform=stateful-application




docker run -i -t \
		-v `pwd`:/terraform/ \
		-v ~/.aws:/root/.aws \
        --entrypoint /bin/sh \
		-w /terraform/platform/stateful-application hashicorp/terraform:0.12.21
