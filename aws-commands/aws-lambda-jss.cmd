set name=%1
set source=%2
call mkdir %name% 2>nul
call mkdir %source% 2>nul
set __PROJECTNAME__=%name%
set __SOURCENAME__=%source%
call node %~dp0/use-env.js %~dp0/azure-resources/lambda-nodejs-source/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs-source/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs-source/lambda.ts %source%/%name%.ts true
if not exist "%source%/tsconfig.json" (
    call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs-source/tsconfig.json %source%/tsconfig.json
)
if not exist "%source%/package.json" (
    call node %~dp0/use-env.js %~dp0/azure-resources/lambda-nodejs-source/package.json %source%/package.json
    cd %source%
    call npm install
    cd ..
)
call az-env.cmd
call gitsync
call az-add %name%
