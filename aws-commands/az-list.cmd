echo off
call az-env
call node %~dp0/az-list.js %AddAllPipelineBranch%
echo on