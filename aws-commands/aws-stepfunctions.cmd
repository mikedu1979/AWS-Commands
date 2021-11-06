set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/stepfunctions/pipeline.yml %name%/pipeline.yml
call node %~dp0/use-env.js %~dp0/azure-resources/stepfunctions/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/use-env.js %~dp0/azure-resources/stepfunctions/definition.json %name%/definition.json
call az-env.cmd
call gitsync
call az pipelines create --name %name% --repository-type tfsgit --repository %AzureDevOpsRepository% --branch master --yaml-path %name%/pipeline.yml --organization %AzureDevOpsOrganization% --project %AzureDevOpsProject%
