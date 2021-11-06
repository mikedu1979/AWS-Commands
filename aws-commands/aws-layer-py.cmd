set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/layer-python/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/layer-python/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/layer-python/layer.dockerfile %name%/layer.dockerfile
call node %~dp0/copy.js %~dp0/azure-resources/layer-python/delete-folder.py %name%/delete-folder.py
call az-env.cmd
call gitsync
call az-add %name%
