# mongodump-s3

[![dockeri.co](http://dockeri.co/image/vikasy/mongodump-s3)](https://hub.docker.com/r/vikasy/mongodump-s3/)

[![.github/workflows/ci.yaml](https://github.com/vik-y/mongodump-s3/actions/workflows/ci.yaml/badge.svg)](https://github.com/vik-y/mongodump-s3/actions/workflows/ci.yaml)

> Docker Image with Alpine Linux, mongodump and awscli for backup mongo database to s3

## New Features 
This project is a fork of Drivetech/mongodump-s3 which is no longer maintained. I have added a lot more features into this fork. Majorly 
1. Slack notifications support
2. Support for using any S3 compatible storage endpoint
3. Support for mongodb 4.x versions 
4. Added tests backed by github actions to ensure the backups actually work

## Use

NOTE: You can take backup to any s3 compatible storage, not just AWS S3. Just use environment variable `AWS_S3_ENDPOINT=<s3-endpoint>` to specify the s3 endpoint which you want to use.

### Periodic backup

Run every day at 2 am

```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname" \
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key" \
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key" \
  -e "AWS_DEFAULT_REGION=us-west-1" \
  -e "S3_BUCKET=your_aws_bucket" \
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *" \
  vikasy/mongodump-s3
```

Run every day at 2 am with full mongodb

```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname" \
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key" \
  -e "AWS_DEFAULT_REGION=us-west-1" \
  -e "S3_BUCKET=your_aws_bucket" \
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *" \
  -e "MONGO_COMPLETE=true" \
  vikasy/mongodump-s3
```

Run every day at 2 am with full mongodb and keep last 5 backups

```bash
docker run -d --name mongodump \
  -v /tmp/backup:/backup \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname" \
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key" \
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key" \
  -e "AWS_DEFAULT_REGION=us-west-1" \
  -e "S3_BUCKET=your_aws_bucket" \
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *" \
  -e "MONGO_COMPLETE=true" \
  -e "MAX_BACKUPS=5" \
  vikasy/mongodump-s3
```

### Immediate backup

```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname" \
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key" \
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key" \
  -e "AWS_DEFAULT_REGION=us-west-1" \
  -e "S3_BUCKET=your_aws_bucket" \
  vikasy/mongodump-s3
```

### Slack Hook
```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname" \
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key" \
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key" \
  -e "AWS_DEFAULT_REGION=us-west-1" \
  -e "S3_BUCKET=your_aws_bucket" \
  -e "SLACK_URI=your_slack_uri" \
  vikasy/mongodump-s3
```


## IAM Policy

You need to add a user with the following policies. Be sure to change `your_bucket` by the correct name.

```xml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1412062044000",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket/*"
            ]
        },
        {
            "Sid": "Stmt1412062128000",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket"
            ]
        }
    ]
}
```

## Extra environment

- `S3_PATH` - Default value is `mongodb`. Example `s3://your_bucket/mongodb`
- `MONGO_COMPLETE` - Default not set. If set doing backup full mongodb
- `MAX_BACKUPS` - Default not set. If set doing it keeps the last n backups in /backup
- `AWS_S3_ENDPOINT` - Default not set. You can use this for backing up to other s3 compatible storages
- `BACKUP_NAME` - Default is `$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz`. If set this is the name of the backup file. Useful when using s3 versioning. (Remember to place .gz extension on your filename)
- `EXTRA_OPTIONS` - Default not set.
- `SLACK_URI` - Default not set. Sends a curl notification to the Slack Incoming Webhook.

## Development Plans 

Features to be implemented 
- [ ] kubernetes yaml files and examples 
- [*] Update CI to push images to docker hub 
- [ ] Improve tests to cover more scenarios 

## Troubleshoot

1. If you get SASL Authentication failure, add  `--authenticationDatabase=admin` to EXTRA_OPTIONS.
2. If you get "Failed: error writing data for collection ... Unrecognized field 'snapshot'", add `--forceTableScan` to EXTRA_OPTIONS.

## License

[MIT](https://tldrlegal.com/license/mit-license)
