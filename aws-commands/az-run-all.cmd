set RunAllPipelineBranch=%1
for /f %%i in ('git branch --show-current') do set GitCurrentBranch=%%i
if [%RunAllPipelineBranch%]==[] set RunAllPipelineBranch=%GitCurrentBranch%
REM Use Branch "%RunAllPipelineBranch%"
call az-env
call node %~dp0/az-run-all.js %RunAllPipelineBranch%
