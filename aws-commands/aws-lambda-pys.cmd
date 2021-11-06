set name=%1
set source=%2
call mkdir %name%
call mkdir %source%
set __SOURCENAME__=%source%
set __PROJECTNAME__=%name%
node %~dp0/use-env.js %~dp0/azure-resources/lambda-python-source/pipeline.yml %name%/pipeline.yml
node %~dp0/copy.js %~dp0/azure-resources/lambda-python-source/cloudformation.yml %name%/cloudformation.yml
node %~dp0/copy.js %~dp0/azure-resources/lambda-python-source/lambda.py %source%/%name%.py true
call az-env.cmd
call gitsync
call az-add %name%
