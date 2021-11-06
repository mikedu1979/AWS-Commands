-- var (dest ? '')
-- var (bucket ? '')
-- var (prefix ? '')
-- var (BuildId ? '')
-- var (Application ? '')
-- var (Version ? '')
-- var (Project ? '')
-- var (AWSAccountId ? '')
-- var (AWSRegion ? '')
-- var (EnvironmentTarget ? '')
-- var (UtcDate ~ "{@yyyy-MM-dd HH:mm:ss@date()}")

-- {
    ````s3
    {
        "Copy": [
            {
                "Source": "{@str(dest)}sample",
                "Destination": "{@str(dest)}database/raw/",
                "NamePrefix": "sample"
            }
        ]
    }
-- }

-- {
    ````athena 5
create database if not exists tests_sample_csv
-- }

-- {
    ````athena 5
drop table if exists tests_sample_csv.raw
-- }

-- {
    ````athena 5
CREATE EXTERNAL TABLE tests_sample_csv.raw (
  `id` bigint, 
  `location_id` bigint, 
  `attention` string, 
  `address_1` string, 
  `address_2` string, 
  `city` string, 
  `state_province` string, 
  `postal_code` string, 
  `country` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '{@str(dest)}database/raw/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='tests_sample_csv', 
  'areColumnsQuoted'='false', 
  'averageRecordSize'='80', 
  'classification'='csv', 
  'columnsOrdered'='true', 
  'compressionType'='none', 
  'delimiter'=',', 
  'objectCount'='1', 
  'recordCount'='20', 
  'sizeKey'='1608', 
  'skip.header.line.count'='1', 
  'typeOfData'='file')
-- }

-- {
    ````athena 5
    drop table if exists tests_sample_csv.refined
-- }

-- {
    ````athena 5
CREATE TABLE tests_sample_csv.refined
WITH (
      format = 'Parquet',
      parquet_compression = 'SNAPPY',
      external_location = '{@str(dest)}database/refined/', 
      bucketed_by = ARRAY['date'], 
      bucket_count = 1
)
AS
select
*,
'{@str(UtcDate)}' as date
from tests_sample_csv.raw
-- }

-- set ( filesCount ) {
    ````lambda
    {
        "name": "serverless-compute--s3-api--{@str(EnvironmentTarget)}",
        "qualifier": "$LATEST",
        "input": {
            "List": [
                "{@str(dest)}"
            ]
        }
    }
-- }

-- {
    ````values [ {@str(filesCount)} ]
-- }

-- {
    ````cloudformation 15
    {
        "action": "Create",
        "name": "{@str(Application)}--tests--{@str(EnvironmentTarget)}--sqs-stack",
        "url": "https://{@str(AWSAccountId)}-{@str(AWSRegion)}-stacks.s3-{@str(AWSRegion)}.amazonaws.com/{@str(Application)}/{@str(EnvironmentTarget)}/{@str(Version)}/{@str(Project)}/{@str(BuildId)}/resources.yml",
        "capabilities": ["CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND"],
        "parameters": {
            "Application": "{@str(Application)}",
            "Version": "{@str(Version)}",
            "Project": "{@str(Project)}",
            "AWSAccountId": "{@str(AWSAccountId)}",
            "AWSRegion": "{@str(AWSRegion)}",
            "EnvironmentTarget": "{@str(EnvironmentTarget)}",
            "BuildId": "{@str(BuildId)}"
        }
    }
-- }

-- {
    ````statemachine
    {
        "arn": "arn:aws:states:{@str(AWSRegion)}:{@str(AWSAccountId)}:stateMachine:serverless-compute--script-runner--prod",
        "input": {
            "job": "Test-Subtask", 
            "source": "{@str(dest)}subtask.sql",
            "input": {
                "Application": "{@str(Application)}",
                "Version": "{@str(Version)}",
                "Project": "{@str(Project)}",
                "AWSAccountId": "{@str(AWSAccountId)}",
                "AWSRegion": "{@str(AWSRegion)}",
                "EnvironmentTarget": "{@str(EnvironmentTarget)}",
                "BuildId": "{@str(BuildId)}"
            }
        }
    }
-- }

-- {
    ````wait 60
-- }

-- {
    ````function
    {
        "job": "Test-Subtask", 
        "source": "{@str(dest)}subtask.sql",
        "input": {
            "Application": "{@str(Application)}",
            "Version": "{@str(Version)}",
            "Project": "{@str(Project)}",
            "AWSAccountId": "{@str(AWSAccountId)}",
            "AWSRegion": "{@str(AWSRegion)}",
            "EnvironmentTarget": "{@str(EnvironmentTarget)}",
            "BuildId": "{@str(BuildId)}"
        }
    }
-- }

-- {
    ````cloudformation 15
    {
        "action": "Delete",
        "name": "{@str(Application)}--tests--{@str(EnvironmentTarget)}--sqs-stack"
    }
-- }