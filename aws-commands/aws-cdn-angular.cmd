set name=%1
call ng new %name% --routing=true --style=scss --strict=true
set __PROJECTNAME__=%name%
call node %~dp0/use-env.js %~dp0/azure-resources/cloudfront-angular/pipeline.yml %name%/pipeline.yml
call node %~dp0/copy.js %~dp0/azure-resources/cloudfront-angular/cloudformation.yml %name%/cloudformation.yml
call node %~dp0/copy.js %~dp0/azure-resources/cloudfront-angular/aws-update.cmd %name%/aws-update.cmd
call az-env.cmd
call gitsync
call az-add %name%
