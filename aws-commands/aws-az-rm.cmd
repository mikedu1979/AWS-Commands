call az-env.cmd
set pipeline=%1
call node %~dp0/delete-devops-pipeline.js --organization %AzureDevOpsOrganization% --project %AzureDevOpsProject% --name %pipeline%
