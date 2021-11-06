set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/users/pipeline.yml %name%/pipeline.yml
call node %~dp0/use-env.js %~dp0/azure-resources/users/cloudformation.yml %name%/cloudformation.yml
call az-env.cmd
call gitsync
call az-add %name%