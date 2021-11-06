set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/lambda-python/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-python/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-python/lambda.py %name%/lambda.py true
call az-env.cmd
call gitsync
call az-add %name%
