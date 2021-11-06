set AddAllPipelineBranch=%1
for /f %%i in ('git branch --show-current') do set GitCurrentBranch=%%i
if [%AddAllPipelineBranch%]==[] set AddAllPipelineBranch=%GitCurrentBranch%
REM Use Branch "%AddAllPipelineBranch%"
call az-env
call node %~dp0/az-add-all.js %AddAllPipelineBranch%
