set name=%1
call mkdir %name%
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/lambda-dotnet/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-dotnet/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/lambda-dotnet/Function.cs %name%/Function.cs true
call node %~dp0/copy.js %~dp0/azure-resources/lambda-dotnet/LambdaDotNet.csproj %name%/LambdaDotNet.csproj true
call node %~dp0/copy.js %~dp0/azure-resources/lambda-dotnet/lambda.sln %name%/lambda.sln true 
call node %~dp0/copy.js %~dp0/azure-resources/lambda-dotnet/aws-lambda-tools-defaults.json %name%/aws-lambda-tools-defaults.json true
call cd %name%
call mkdir Properties
call cd ..
call node %~dp0/copy.js %~dp0/azure-resources/lambda-dotnet/Properties/launchSettings.json %name%/Properties/launchSettings.json true
call az-env.cmd
call gitsync
echo on
call az-add %name%
