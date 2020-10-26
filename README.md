# ENCORA DEVOPS MODULAR TASK

- [ENCORA DEVOPS MODULAR TASK](#encora-devops-modular-task)
  - [Platform Levels](#platform-levels)
  - [Platform dependency](#platform-dependency)
  - [Platform creation steps](#platform-creation-steps)
  - [The stateful application](#the-stateful-application)
    - [General information](#general-information)
      - [1. Wordpress](#1-wordpress)
      - [2. MySQL](#2-mysql)
    - [Deployment](#deployment)
  - [The stateless application](#the-stateless-application)
    - [General information](#general-information-1)
      - [1. ECS Cluster](#1-ecs-cluster)
      - [2. MySQL RDS instance](#2-mysql-rds-instance)
      - [3. Application Load Balancer](#3-application-load-balancer)
    - [Deployment](#deployment-1)

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

## Platform creation steps

Once you have your AWS credentials on ~/.aws/credentials like this:

```bash
[nstask]
aws_access_key_id=LAGALLETADEANIMALITOTIENEMUCHAPROTEINA
aws_secret_access_key=12y3tamarindoonetwotreetamarindo
```

Create the platforms one by one
Where:

- aws_profile = refers to your AWS profile credentials as you have them set on your workstation
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

The application deploys two EC2 instances:

#### 1. Wordpress

- Description: Apache 2/ PHP 7 service configured with Wordpress 5.5.1. Deployed in an auto-scaling group.
- Subnet: public.
- Name tag value: `wordpress-<ENVIRONMENT>`
- OS version: Ubuntu 20.04

#### 2. MySQL

- Description: MySQL server.
- Subnet: private.
- Name tag value: `mysql-<ENVIRONMENT>`
- OS version: Ubuntu 20.04

### Deployment

Follow these steps to deploy the application:

1. Generate two public/private key pairs.

Run the following commands to create one key pair for the evaluator.

```bash
$ cd platform/stateful-application
$ ssh-keygen -t rsa -b 4096 -N "" -f files/id_rsa_evaluator
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

```
$ aws configure --profile <PROFILE_NAME>
```

3. Create a DynamoDB table for `cloud` to allow locking the statefile while running Terraform:

- Table name: `terraform_states`
- Table key: `LockID`


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
















## The stateless application

### General information

The application deploys the following:

#### 1. ECS Cluster

- Description: ECS Cluster running on EC2.
- Services: 1
- Running tasks: 6
- Image: [wordpress](https://hub.docker.com/_/wordpress)
- Number of EC2 instances: 2
- Subnet: private

#### 2. MySQL RDS instance

- Description: MySQL server
- Subnet: private

#### 3. Application Load Balancer

- Description: AWS Application Load Balancer. Used to receive requests from the internet and forward it to the cluster.
- Subnet: public

### Deployment

Follow these steps to deploy the application:

1. Generate a public/private key pair.

```bash
$ cd platform/stateless-application
$ ssh-keygen -t rsa -b 4096 -N "" -f files/id_rsa_evaluator
```

These commands create the key pairs under `files` directory:

```bash
$ ls -1a files/
.
..
id_rsa_evaluator
id_rsa_evaluator.pub
```

Note: This key pair will allow you to connecto to the EC2 instances to trorubleshoot issues with ECS. It will require an update to to the security group of the EC2 instances.

1. Crear AWS CLI profile

```
$ aws configure --profile <PROFILE_NAME>
```

3. Create a DynamoDB table for `cloud` to allow locking the statefile while running Terraform:

- Table name: `terraform_states`
- Table key: `LockID`


4. Create a S3 bucket and the directories structure required to store Terraform statefile

Create the following directories in the bucket. Repeat per `<PLATFORM_NAME>`.

```text
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/cloud
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/stateful-application
```

5. Create the Terraform configuration file

```
platform/cloud/vars_<APPLICATION_ENVIRONMENT_NAME>.tfvars
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
