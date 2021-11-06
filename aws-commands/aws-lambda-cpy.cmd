set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/lambda-python-container/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-python-container/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-python-container/job.dockerfile %name%/job.dockerfile
call node %~dp0/copy.js %~dp0/azure-resources/lambda-python-container/entry.py %name%/entry.py
call node %~dp0/copy.js %~dp0/azure-resources/lambda-python-container/entry-tests.py %name%/entry-tests.py
call az-env.cmd
call gitsync
call az-add %name%
