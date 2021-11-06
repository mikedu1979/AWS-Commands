set RunOnePipelineName=%1
set RunOnePipelineBranch=%2
for /f %%i in ('git branch --show-current') do set GitCurrentBranch=%%i
if [%RunOnePipelineBranch%]==[] set RunOnePipelineBranch=%GitCurrentBranch%
REM Use Branch "%RunOnePipelineBranch%"
call az-env
call az pipelines run --name %RunOnePipelineName% --branch %RunOnePipelineBranch% --organization %AzureDevOpsOrganization% --project %AzureDevOpsProject%