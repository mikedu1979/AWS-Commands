set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/lambda-nodejs/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs/lambda.ts %name%/lambda.ts true
call node %~dp0/use-env.js %~dp0/azure-resources/lambda-nodejs/package.json %name%/package.json true
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs/tsconfig.json %name%/tsconfig.json true
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs/test.ts %name%/test.ts true
call node %~dp0/copy.js %~dp0/azure-resources/lambda-nodejs/test.cmd %name%/test.cmd true
cd %name%
call npm install
cd ..
call az-env.cmd
call gitsync
echo on
call az-add %name%
