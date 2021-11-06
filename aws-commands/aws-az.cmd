REM create environments.yml for all azure projects
REM Parameters: [__APPLICATIONNAME__] [__ACCOUNTID__] [__REGION__] [__AZUREDEVOPSORGANIZATION__] [__AZUREDEVOPSPROJECT__] [__AZUREDEVOPSREPOSITORY__]
set __APPLICATIONNAME__=%1
set __ACCOUNTID__=%2
set __REGION__=%3
set __AZUREDEVOPSORGANIZATION__=%4
set __AZUREDEVOPSPROJECT__=%5
set __AZUREDEVOPSREPOSITORY__=%6

call node %~dp0/use-env.js %~dp0/azure-resources/environments.yml environments.yml
call node %~dp0/use-env.js %~dp0/azure-resources/.gitignore .gitignore
call node %~dp0/use-env.js %~dp0/azure-resources/az-env.cmd az-env.cmd
call node %~dp0/use-env.js %~dp0/azure-resources/az-env.staging.cmd az-env.staging.cmd
