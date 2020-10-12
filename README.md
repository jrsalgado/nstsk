# NEARSOFT DEVOPS MODULAR TASK

## Platform Levels
- cloud
- k8s
- services-k8s
- ops-k8s

## Platform dependency
1- cluod
2- k8s
3- [ services-k8s, ops-k8s]

## Paltforms cration steps
Once you have your aws credentials on ~/.aws/credentials like this
```bash
[nstask]
aws_access_key_id=LAGALLETADEANIMALITOTIENEMUCHAPROTEINA
aws_secret_access_key=12y3tamarindoonetwotreetamarindo
```

Create the platforms one by one
Where 
  - aws_profile = refers to your aws profile credentials as you have them set on your workstation
  - app_env = refers to an environment or the interviewed name
  - platform = the platform level you are going to create for the task
```bash
# Start with the cloud platform level [ mostly network, setup other platforms are going to use this resources]
$ make apply aws_profile=nstask app_env=natanael-cano platform=cloud
# Once cloud is created, you can continue with the K8s cluster platform [ This platform is the base for k8s app microservices and ops services running on containers]
$ make apply aws_profile=nstask app_env=natanael-cano platform=k8s
# Once you hav a K8s cluster you can create your K8s resources and deploy the app microservices and operational tools
$ make apply aws_profile=nstask app_env=natanael-cano platform=services-k8s
$ make apply aws_profile=nstask app_env=natanael-cano platform=ops-k8s

```
