## Requirements

### Data

Use [crawl.sh](./crawl.sh) to get a list of websites, it depends on _httrack_, for example:

```
❯ ./crawl.sh https://en.wikipedia.org/wiki/Sorting_algorithm
```

#### Upload to Google Cloud Storage

The following command synchronizes local and remote data.

```
❯ gsutil -m rsync -r data "gs://{{BUCKET_NAME}}/data"
```

### Inverted Index

Clone branch [mr-search-engine](https://github.com/sharon1160/inverted-index/tree/mr-search-engine) from [inverted-index repository](https://github.com/sharon1160/inverted-index). Compile and create a JAR executable.

#### Upload to Google Cloud Storage

```
❯ gsutil cp target/inverted-index-1.0-SNAPSHOT-jar-with-dependencies.jar "gs://{{BUCKET_NAME}}/invertedindex.jar"
```

#### Create and submit job

Create a job following Google Dataproc schema, for example:

```
{
  "reference": {
    "jobId": "{{JOB_ID}}",
    "projectId": "{{PROJECT_ID}}"
  },
  "placement": {
    "clusterName": "{{BUCKET_NAME}}"
  },
  ...
  "hadoopJob": {
    "jarFileUris": [
      "gs://{{BUCKET_NAME}}/invertedindex.jar"
    ],
    "args": [
      "gs://{{BUCKET_NAME}}/data",
      "gs://{{BUCKET_NAME}}/invertedindex-output"
    ],
    "mainClass": "com.mycompany.app.InvertedIndex"
  }
}
```

```
❯ gcloud dataproc jobs wait {{JOB_ID}} --project {{PROJECT_ID}} --region {{REGION}}
```

#### Sync results

The following command synchronizes local and remote data.

```
❯ gsutil -m rsync -r "gs://{{BUCKET_NAME}}/invertedindex-output" output/inverted-index
```
