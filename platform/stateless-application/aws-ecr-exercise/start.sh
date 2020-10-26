docker run -it -v $PWD:/app -v ~/.aws:/root/.aws node:12-alpine /bin/sh
cd /app/files
node index.js
export AWS_PROFILE=nstask
export AWS_SDK_LOAD_CONFIG=1
export AWS_SHARED_CREDENTIALS_FILE=/root/.aws/credentials
export AWS_CONFIG_FILE=/root/.aws/config
node index.js
aws  ecr get-login-password --region region --profile nstask
docker login -u AWS -p $(aws2 --profile nstask ecr get-login-password --region region) account.dkr.ecr.region.amazonaws.com

aws3 --profile nstask  ecr get-login-password --region region | docker login --username AWS --password-stdin account.dkr.ecr.region.amazonaws.com
docker build -t tocleanup .

docker push account.dkr.ecr.region.amazonaws.com/tocleanup:latest

~/.aws:/root/.aws 
alias aws3='docker run --rm -v ~/.aws:/root/.aws -it amazon/aws-cli'