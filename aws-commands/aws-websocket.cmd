set name=%1
set userproject=%2
call mkdir %name%
set __PROJECTNAME__=%name%
set __USERSPROJECT__=%userproject%
call node %~dp0/use-env.js %~dp0/azure-resources/websocket/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/websocket/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/websocket/lambda.ts %name%/lambda.ts true
call node %~dp0/use-env.js %~dp0/azure-resources/websocket/package.json %name%/package.json true
call node %~dp0/copy.js %~dp0/azure-resources/websocket/tsconfig.json %name%/tsconfig.json true
cd %name%
call npm install
cd ..
call az-env.cmd
call gitsync
echo on
call az-add %name%
