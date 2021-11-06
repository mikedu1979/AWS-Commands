for /f "delims=" %%a in ('aws ecr get-login-password') do @set password=%%a
docker login --password %password% --username AWS %1
