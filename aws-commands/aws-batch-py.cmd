set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/batch-python/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/batch-python/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/batch-python/job.dockerfile %name%/job.dockerfile
call node %~dp0/copy.js %~dp0/azure-resources/batch-python/lambda.py %name%/lambda.py
call az-env.cmd
call gitsync
call az-add %name%
