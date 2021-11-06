SET profile=%1
IF "%profile%"=="" (SET profile=default)
ECHO profile=%profile%
SET SessionDuration=%2
IF "%SessionDuration%"=="" (SET SessionDuration=86400)
ECHO SessionDuration=%SessionDuration%
FOR /F "tokens=* USEBACKQ" %%F IN (`call aws configure get region --profile %profile%`) DO (
    SET AWS_DEFAULT_REGION=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`call aws sts get-caller-identity --profile %profile% --region %AWS_DEFAULT_REGION% --output text`) DO (
    SET identity=%%F
)
FOR /F "tokens=1" %%F IN ("%identity%") DO (
    SET AWS_ACCOUNT_ID=%%F
)
FOR /F "tokens=2" %%F IN ("%identity%") DO (
    SET UserArn=%%F
)
SET MfaArn=%UserArn::user/=:mfa/%
SET /P token="Input the Token Code: "
FOR /F "tokens=* USEBACKQ" %%F IN (`aws sts get-session-token --serial-number %MfaArn% --duration-seconds %SessionDuration% --profile %profile% --region %AWS_DEFAULT_REGION% --output text --token-code %token%`) DO (
    SET StsToken=%%F
)
FOR /F "tokens=2" %%F IN ("%StsToken%") DO (
    SET AWS_ACCESS_KEY_ID=%%F
)
FOR /F "tokens=4" %%F IN ("%StsToken%") DO (
    SET AWS_SECRET_ACCESS_KEY=%%F
)
FOR /F "tokens=5" %%F IN ("%StsToken%") DO (
    SET AWS_SESSION_TOKEN=%%F
)
ECHO AWS_DEFAULT_REGION=(%AWS_DEFAULT_REGION%)
ECHO AWS_ACCOUNT_ID=(%AWS_ACCOUNT_ID%)
ECHO AWS_ACCESS_KEY_ID=(%AWS_ACCESS_KEY_ID%)
ECHO AWS_SECRET_ACCESS_KEY=(%AWS_SECRET_ACCESS_KEY%)
ECHO AWS_SESSION_TOKEN=(%AWS_SESSION_TOKEN%)