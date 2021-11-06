for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "fullstamp=%1%YYYY%-%MM%-%DD%-%HH%-%Min%-%Sec%"
set "timekey=%fullstamp:-=%"
set "BuildId=debug-%timekey%"

call ../az-env.cmd
call ../az-env.staging.cmd

set Version=1.0.0
set DataScriptRunner=CAVML-ScriptRunner
set Project=${__PROJECTNAME__}
set bucket=%AWSAccountId%-%AWSRegion%-stacks

set "fullprefix=%Application%/%EnvironmentTarget%/%Version%/%Project%/%BuildId%/"
set "dest=s3://%bucket%/%Application%/%EnvironmentTarget%/%Version%/%Project%/%BuildId%/"

call aws s3 cp . %dest% --recursive  --exclude "*" --include "*.yml"
call aws s3 cp . %dest% --recursive  --exclude "*" --include "*.sql"
call aws s3 cp . %dest% --recursive  --exclude "*" --include "*.csv"

REM usually this should target prod

call aws stepfunctions start-execution ^
 --state-machine-arn arn:aws:states:%AWSRegion%:%AWSAccountId%:stateMachine:serverless-compute--script-runner--prod ^
 --name "%Application%--%Project%--%EnvironmentTarget%--%Version%.%BuildId%" ^
 --input "{\"source\":\"%dest%tasks.sql\",\"input\":{\"dest\":\"%dest%\",\"bucket\":\"%bucket%\",\"prefix\":\"%fullprefix%\",\"Application\":\"%Application%\",\"Version\":\"%Version%\",\"Project\":\"%Project%\",\"AWSAccountId\":\"%AWSAccountId%\",\"AWSRegion\":\"%AWSRegion%\",\"EnvironmentTarget\":\"%EnvironmentTarget%\",\"BuildId\":\"%BuildId%\"}}"

REM timestamp: %BuildId%