make apply aws_profile=nstask 

make fmt aws_profile=nstask platform=stateful-application


docker run -i -t \
		-v `pwd`:/terraform/ \
		-v ~/.aws:/root/.aws \
        --entrypoint /bin/sh \
		-w /terraform/platform/stateful-application hashicorp/terraform:0.12.21
