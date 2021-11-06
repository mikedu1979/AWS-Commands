set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/copy.js %~dp0/azure-resources/serverless/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/use-env.js %~dp0/azure-resources/serverless/run.cmd %name%/run.cmd
call node %~dp0/use-env.js %~dp0/azure-resources/serverless/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/serverless/resources.yml %name%/resources.yml
call node %~dp0/copy.js %~dp0/azure-resources/serverless/tasks.sql %name%/tasks.sql
call node %~dp0/copy.js %~dp0/azure-resources/serverless/subtask.sql %name%/subtask.sql
call node %~dp0/copy.js %~dp0/azure-resources/serverless/sample.csv %name%/sample.csv
call az-env.cmd
call gitsync
call az-add %name%