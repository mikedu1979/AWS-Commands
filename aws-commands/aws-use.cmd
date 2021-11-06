SET profile=%1
IF "%profile%"=="" (SET profile=default)
ECHO profile=%profile%
FOR /F "tokens=* USEBACKQ" %%F IN (`call aws configure get region --profile %profile%`) DO ( SET AWS_DEFAULT_REGION=%%F)
ECHO AWS_DEFAULT_REGION=%AWS_DEFAULT_REGION%
FOR /F "tokens=* USEBACKQ" %%F IN (`call aws configure get aws_access_key_id --profile %profile%`) DO ( SET AWS_ACCESS_KEY_ID=%%F)
ECHO AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID%
FOR /F "tokens=* USEBACKQ" %%F IN (`call aws configure get aws_secret_access_key --profile %profile%`) DO ( SET AWS_SECRET_ACCESS_KEY=%%F)
ECHO AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY%
FOR /F "tokens=* USEBACKQ" %%i IN (`call aws sts get-caller-identity --profile %profile% --region %AWS_DEFAULT_REGION% --output text`) DO ( SET line=%%i)
SET AWS_ACCOUNT_ID=%line:~0,12%
ECHO AWS_ACCOUNT_ID=%AWS_ACCOUNT_ID%