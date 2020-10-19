# ENCORA DEVOPS MODULAR TASK

- [ENCORA DEVOPS MODULAR TASK](#encora-devops-modular-task)
  - [Platform Levels](#platform-levels)
  - [Platform dependency](#platform-dependency)
  - [AWS deployment](#aws-deployment)
  - [Platform creation steps](#platform-creation-steps)
  - [The stateful application](#the-stateful-application)
    - [General information](#general-information)
      - [Wordpress](#wordpress)
      - [MySQL](#mysql)
    - [Deployment](#deployment)

## Platform Levels

- cloud
- k8s
- services-k8s
- ops-k8s
- stateful-application

## Platform dependency

1- cloud
2- k8s
3- [ services-k8s, ops-k8s, stateful-application ]

## AWS deployment

All the infrastructure deploys by default on `us-east-1`. If you want to deploy on a different region pass the  `aws_region` parameter to `make`.

## Platform creation steps

Create a named profile for the AWS Command Line Interface (CLI).  Once you have your AWS credentials on `~/.aws/credentials` like this:

```bash
[nstask]
aws_access_key_id=LAGALLETADEANIMALITOTIENEMUCHAPROTEINA
aws_secret_access_key=12y3tamarindoonetwotreetamarindo
```

Create the platforms one by one, where:

- aws_profile = refers to your AWS profile credentials as you have them set on your workstation.
- aws_region = name of the AWS region where the infrastructure will be deployed
- app_env = refers to an environment or the interviewed name
- platform = the platform level you are going to create for the task

```bash
# Start with the cloud platform level [ mostly network, setup other platforms are going to use this resources]
$ make apply aws_profile=nstask app_env=natanael-cano platform=cloud

# Once the cloud platform is created, you can continue with the K8s cluster platform [ This platform is the base for k8s app microservices and ops services running on containers]
$ make apply aws_profile=nstask app_env=natanael-cano platform=k8s

# Once you have a K8s cluster you can create your K8s resources and deploy the app microservices and operational tools
$ make apply aws_profile=nstask app_env=natanael-cano platform=services-k8s
$ make apply aws_profile=nstask app_env=natanael-cano platform=ops-k8s
```

## The stateful application

### General information

The application deploys three EC2 instances:

#### Wordpress

- Description: Apache 2/ PHP 7 service configured with Wordpress 5.5.1. Deployed in an auto-scaling group.
- Subnet: public.
- Name tag value: `wordpress-<ENVIRONMENT>`
- OS version: Ubuntu 20.04

#### MySQL

- Description: MySQL server.
- Subnet: private.
- Name tag value: `mysql-<ENVIRONMENT>`
- OS version: Ubuntu 20.04

### Deployment

Follow these steps to deploy the application:

1. Generate two public/private key pairs.

Run the following commands to create one key pair for the evaluator.

```bash
$ ssh-keygen -t rsa -b 4096 -N "" -f platform/stateful-application/files/id_rsa_evaluator
```

These commands create the key pairs under `files` directory:

```bash
$ ls -1a files/
.
..
id_rsa_evaluator
id_rsa_evaluator.pub
```

Note: This key pair will be used by ansible to provision the Wordpress and MySQL servers.

2. Crear AWS CLI profile

```bash
$ aws configure --profile <PROFILE_NAME>
```

3. Create a DynamoDB table for `cloud` to allow locking the statefile while running Terraform:

- Table name: `terraform_states`
- Tabke key: `LockID`

4. Create a S3 bucket and the directories structure required to store Terraform statefile

Create the following directories in the bucket. Repeat per `<PLATFORM_NAME>`.

```text
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/cloud
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/stateful-application
```

5. Create the Terraform configuration file

```
platform/cloud/vars_<APPLICATION_ENVIRONMENT_NAME>.tfvars
platform/stateful-app/vars_<APPLICATION_ENVIRONMENT_NAME>.tfvars
```

6. Create the infrastructure

Run the following commands will deploy the application:

```bash
# Init and deploy the cloud platform level
$ make init aws_profile=<AWS_PROFILE_NAME> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud
$ make apply aws_profile=<AWS_PROFILE_NAME> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud

# Init and deploy the stateful-application platform level
$ make init aws_profile=<AWS_PROFILE_NAME> app_env=junior-h platform=stateful-application
$ make apply aws_profile=<AWS_PROFILE_NAME> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateful-application
```

7. Build Ansible docker image

```bash
# build image
$ make ansible-build
```

8. Provision Wordpress and MySQL servers

```bash
# Run provisioning
$ make provision-wordpress aws_profile=<AWS_PROFILE_NAME> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateful-application
```

**Note:** Wait at least 90 seconds after deploying the servers before running this step. Otherwise Ansible won't find them and will throw an error message.

9. Checking the application was correctly deployed

Open your browser in `http://<WORDPRESS_SERVER_PUBLIC_IP_ADDRESS>/` to confirm the app is working.
