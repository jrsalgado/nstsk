# ENCORA DEVOPS MODULAR TASK

- [ENCORA DEVOPS MODULAR TASK](#encora-devops-modular-task)
  - [Platform Levels](#platform-levels)
  - [Platform dependency](#platform-dependency)
  - [AWS deployment](#aws-deployment)
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
    - [Undeployment](#undeployment)
    - [Suggested changes to the infrastructure to evaluate candidates](#suggested-changes-to-the-infrastructure-to-evaluate-candidates)
      - [Optimize the provided Wordpress' Dockerfile](#optimize-the-provided-wordpress-dockerfile)
      - [Break the ECS cluster tasks definition](#break-the-ecs-cluster-tasks-definition)
      - [Break the Security Group providing access to the database](#break-the-security-group-providing-access-to-the-database)

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
- Table key: `LockID`

4. Create a S3 bucket and the directories structure required to store Terraform statefile

Create the following directories in the bucket. Repeat per `<AWS_PLATFORM_NAME>`.

```text
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/cloud
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/stateful-application
```

5. Create the Terraform configuration file for the `cloud` platform:

```
$ touch platform/cloud/vars_<APPLICATION_ENVIRONMENT_NAME>.tfvars
```

6. Create the infrastructure

Run the following commands to deploy the application:

```bash
# Init and deploy the cloud platform level
$ make init aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud
$ make apply aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud

# Init and deploy the stateful-application platform level
$ make init aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateful-application
$ make apply aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateful-application
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
$ ssh-keygen -t rsa -b 4096 -N "" -f platform/stateless-application/files/id_rsa_evaluator
```

These commands create a key pair under `files` directory:

```bash
$ ls -l1 platform/stateless-application/files/id_rsa_evaluator*
files/id_rsa_evaluator
files/id_rsa_evaluator.pub
```

This key pair will allow you to connecto to the EC2 instances to trorubleshoot issues with ECS. It will require an update to to the security group of the EC2 instances.

2. Crear AWS CLI profile

```bash
$ aws configure --profile <PPROFILE_NAME>
```

3. Create a DynamoDB table for `cloud` to allow locking the statefile while running Terraform:

- Table name: `terraform_states`
- Table key: `LockID`

4. Create a S3 bucket and the directories structure required to store Terraform statefile

Create the following directories in the bucket. Repeat per `<AWS_PLATFORM_NAME>`.

```text
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/cloud
s3://<S3_BUCKET_NAME>/Task/<APPLICATION_ENVIRONMENT_NAME>/stateful-application
```

5. Create the Terraform configuration file for the `cloud` platform:

```bash
$ touch platform/cloud/vars_<APPLICATION_ENVIRONMENT_NAME>.tfvars
```

6. Create the infrastructure

Run the following commands to deploy the application:

```bash
# Init and deploy the cloud platform level
$ make init aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud
$ make apply aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud

# Init and deploy the stateful-application platform level
$ make init aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateless-application
$ make apply aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateless-application
```

7. Upload the wordpress docker image:

The Terraform code deploys all he infrastructure, except for the wordpress docker image in the ECR repository. It was implemented this way so the candidate could create the docker image and upload it to ECR after running some optimizations.

7.1. Download the latest release of the Wordpress on your local box:

```bash
$ docker pull wordpress
```

7.2. Push the dockek image to ECR:

- Open the AWS console in your browser: https://console.aws.amazon.com/ecr/repositories?#

- Click on the ECR repository whose name matches: `<ENVIRONMENT_NAME>-wordpress`

- Click on `View push commands`
- Run the provided commands from your local box, excepting the `docker build`.

9. Update the docker images by the cluster

- Open https://console.aws.amazon.com/ecs/home?#/taskDefinitions

- Click on wordpress.
- Click on `Actions`
- Click on `Update Service`
- Click on `Next step` three times.
- Click on `Update Service`.
- Wait around 3 minutes and then check the `Tasks` tab to confirm the tasks in `RUNNING` state.



10. Check the application was deployed correctly:

Check the output of the last `make` command and open the provided URL in your browser:

```text
...
Outputs:

ecs_alb_public_dns = http://ecs-load-balancer-318411130.us-east-1.elb.amazonaws.com
```

### Undeployment

To undeploy the application run `terraform destroy` in reverse of the creation of the infrastructure:

```bash
$ make destroy aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=stateless-application
$ make destroy aws_profile=<AWS_PROFILE_NAME> aws_region=<AWS_REGION> app_env=<APPLICATION_ENVIRONMENT_NAME> platform=cloud
```

It is very important to undeploy the infrastructure after finishing an interview to avoid paying for unused infrastructure. 

### Suggested changes to the infrastructure to evaluate candidates

#### Optimize the provided Wordpress' Dockerfile

Ask the candidate to optimize the Docker image size of the Docker image in [Dockerfile.bad](platform/stateless-application/files/Dockerfile.bad).

Download the file and send the docker dile to the candidate by email.

The fixed Dockerfile is here [Dockerfile.good](platform/stateless-application/files/Dockerfile.good)

#### Break the ECS cluster tasks definition

Make changes so the task definition and ask the candidate to troubleshoot the issue

#### Break the Security Group providing access to the database

Change the Security Group access rule providing access to the database and ask the candidate to trouble 