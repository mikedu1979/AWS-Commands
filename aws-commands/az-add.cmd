set CreatePipelineName=%1
set CreatePipelineBranch=%2
for /f %%i in ('git branch --show-current') do set GitCurrentBranch=%%i
if [%CreatePipelineBranch%]==[] set CreatePipelineBranch=%GitCurrentBranch%
call az-env
call az pipelines create --name %CreatePipelineName% --repository-type tfsgit --repository %AzureDevOpsRepository% --branch %CreatePipelineBranch% --yaml-path %CreatePipelineName%/pipeline.yml --organization %AzureDevOpsOrganization% --project %AzureDevOpsProject%
