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

### PageRank

Clone branch [mr-search-engine](https://github.com/jersonzc/pagerank/tree/mr-search-engine) from [pagerank repository](https://github.com/jersonzc/pagerank). Compile and create a JAR executable.

#### Upload to Google Cloud Storage

```
❯ gsutil cp target/pagerank-1.0-SNAPSHOT-jar-with-dependencies.jar  "gs://{{BUCKET_NAME}}/pagerank.jar"
```

#### Create and submit job

Create a job following Google Dataproc schema, for example:

```
POST /v1/projects/{{PROJECT_ID}}/regions/{{REGION}}/jobs:submit/
{
  "projectId": "{{PROJECT_ID}}",
  "job": {
    "placement": {
      "clusterName": "{{CLUSTER_NAME}}"
    },
    "statusHistory": [],
    "reference": {
      "jobId": "{{JOB_ID}}",
      "projectId": "{{PROJECT_ID}}"
    },
    "hadoopJob": {
      "properties": {},
      "jarFileUris": [
        "gs://{{BUCKET_NAME}}/pagerank.jar"
      ],
      "args": [
        "gs://{{BUCKET_NAME}}/data",
        "gs://{{BUCKET_NAME}}/pagerank-temp",
        "gs://{{BUCKET_NAME}}/pagerank-output",
        "4"
      ],
      "mainClass": "com.mycompany.app.PageRank"
    }
  }
}
```

```
❯ gcloud dataproc jobs wait {{JOB_ID}} --project {{PROJECT_ID}} --region {{REGION}}
```

#### Sync results

The following command synchronizes local and remote data.

```
❯ gsutil -m rsync -r "gs://{{BUCKET_NAME}}/pagerank-output" output/pagerank
```
