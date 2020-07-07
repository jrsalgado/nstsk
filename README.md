# NEARSOFT DEVOPS MODULAR TASK

## Platform Levels
- cloud
- k8s
- services
- ops

## Create Platform
Once you have your aws credentials on ~/.aws/credentials like this
```bash
[nstask]
aws_access_key_id=LAGALLETADEANIMALITOTIENEMUCHAPROTEINA
aws_secret_access_key=12y3tamarindoonetwotreetamarindo
```
Now you can select a platform to operate with terraform
```bash
$ make plan aws_profile=nstask platform=cloud
$ make init aws_profile=nstask platform=cloud
$ make apply aws_profile=nstask platform=cloud
$ make destroy aws_profile=nstask platform=cloud
```