# Check Parameters
param ( [Parameter(Mandatory=$true)] $tokenCode
      )

function main() {

    # Variables
    [String] $MfaArn = "arn:aws:iam::490971649303:mfa/zhenyu.shi"
    [String] $defaultRegion = "ap-southeast-2"
    [String] $profileName = "default"
    [Int32] $sessionDuration = 43500 # 12 Hours

    Write-Output "Running AWS Powershell Access with MFA"
    Write-Output "  Calling AWS STS GetSession Token to get temporary credentials"
    $sessionData = Get-STSSessionToken -DurationInSeconds $sessionDuration -SerialNumber $MfaArn -TokenCode $tokenCode -ProfileName $profileName -Region $defaultRegion

    # remove existing AWS Environment variables
    #unset AWS_ACCESS_KEY_ID
    #unset AWS_SECRET_ACCESS_KEY
    #unset AWS_SESSION_TOKEN
    #unset AWS_DEFAULT_REGION

    Write-Output "  Parsing Response and setting AWS CLI Environmental Variables"
    $access_key = $sessionData.AccessKeyId
    $secret_access_key = $sessionData.SecretAccessKey
    $session_token = $sessionData.SessionToken

    Write-Output "  Temporary Credentials are:"
    Write-Output "    AWS_ACCESS_KEY_ID=$access_key"
    Write-Output "    AWS_SECRET_ACCESS_KEY=$secret_access_key"
    Write-Output "    AWS_SESSION_TOKEN=$session_token"
    Write-Output "    AWS_DEFAULT_REGION=$defaultRegion"
    
    # Set environmental variables
    $Env:AWS_ACCESS_KEY_ID = $access_key
    $Env:AWS_SECRET_ACCESS_KEY = $secret_access_key
    $Env:AWS_SESSION_TOKEN = $session_token
    $Env:AWS_DEFAULT_REGION=$defaultRegion
    
    echo "Temporary AWS Access Credentials configured"

}

main $tokenCode
return 0

