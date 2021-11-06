-- var (BuildId ? '')
-- var (Application ? '')
-- var (Version ? '')
-- var (Project ? '')
-- var (AWSAccountId ? '')
-- var (AWSRegion ? '')
-- var (EnvironmentTarget ? '')

-- {
````sqs
{
    "Push": {
        "QueueUrl": "https://sqs.{@str(AWSRegion)}.amazonaws.com/{@str(AWSAccountId)}/{@str(Application)}--{@str(Project)}--{@str(EnvironmentTarget)}--source",
        "MessageBody": {
            "Key": "I have a message"
        }
    }
}
-- }

-- set ( messageCount ) {
````sqs
{
    "Count": "https://sqs.{@str(AWSRegion)}.amazonaws.com/{@str(AWSAccountId)}/{@str(Application)}--{@str(Project)}--{@str(EnvironmentTarget)}--source"
}
-- }

-- while (
    -- eval ( messageCount > 0 )
-- ) {

    -- {
    ````sqs
    {
        "Purge": "https://sqs.{@str(AWSRegion)}.amazonaws.com/{@str(AWSAccountId)}/{@str(Application)}--{@str(Project)}--{@str(EnvironmentTarget)}--source"
    }
    -- }

    -- set ( messageCount ) {
    ````sqs
    {
        "Count": "https://sqs.{@str(AWSRegion)}.amazonaws.com/{@str(AWSAccountId)}/{@str(Application)}--{@str(Project)}--{@str(EnvironmentTarget)}--source"
    }
    -- }

-- }
