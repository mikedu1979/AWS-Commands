set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/layer-nodejs/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/layer-nodejs/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/layer-nodejs/layer.dockerfile %name%/layer.dockerfile
call node %~dp0/use-env.js %~dp0/azure-resources/layer-nodejs/package.json %name%/package.json
call az-env.cmd
call gitsync
call az-add %name%
