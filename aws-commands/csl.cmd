echo off
echo Cloud Snippet List
echo ====================================
echo Git Commands:
echo # You need to install git cli for Windows first.
echo ------------------------------------
echo     gitsync [Commiet Name]
echo     # Run git add, commit, push and pull to synchronize code
echo ------------------------------------
echo ====================================
echo AWS Login Commands:
echo # You need to install aws cli for Windows first.
echo ------ ------ ------ ------
echo     aws-use [Profile Name]
echo     # use an AWS profile
echo ------ ------ ------ ------
echo     aws-mfa [Profile Name]
echo     # run MFA authentication with an AWS profile
echo ------ ------ ------ ------

echo AWS Azure DevOps Commnands:
echo ** You need to install Azure cli and install devops extension
echo aws-az [Application Name] [AWS Account Id] [AWS Region Name] [AWS Lambda Role ARN] >> create environments.yml for Azure DevOps Pipelines
echo aws-lambda-py [Project Name] : create an AWS Lambda Python project with Azure DevOps pipelines
echo aws-lambda-pys [Project Name] [Source Folder] : create an AWS Lambda Python project with Azure DevOps pipelines and Pythone source codes from source folder
echo aws-lambda-js [Project Name] : create an AWS Lambda NodeJS project with Azure DevOps pipelines
echo aws-lambda-jss [Project Name] [Source Folder] : create an AWS Lambda NodeJS project with Azure DevOps pipelines and NodeJS source codes from source folder

echo on