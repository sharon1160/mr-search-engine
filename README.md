# busca.pe

**busca.pe** is your _one and only_ search engine. It is based on MapReduce algorithms such as Inverted Index and PageRank, which allows to process a huge amount of data in a parallel, reliable and efficient way. Start now your search experience by navigating on our delightful interface. :)

## Table of contents

- [busca.pe](#buscape)
  - [Table of contents](#table-of-contents)
  - [Architecture](#architecture)
  - [Requirements](#requirements)
    - [Data](#data)
      - [Upload to Google Cloud Storage](#upload-to-google-cloud-storage)
    - [Inverted Index](#inverted-index)
      - [Upload to Google Cloud Storage](#upload-to-google-cloud-storage-1)
      - [Create and submit job](#create-and-submit-job)
      - [Sync results](#sync-results)
    - [PageRank](#pagerank)
      - [Upload to Google Cloud Storage](#upload-to-google-cloud-storage-2)
      - [Create and submit job](#create-and-submit-job-1)
      - [Sync results](#sync-results-1)
    - [Join part-r-\*](#join-part-r---)

## Architecture

TO-DO

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

Clone branch [mr-search-engine](https://github.com/sharon1161/inverted-index/tree/mr-search-engine) from [inverted-index repository](https://github.com/sharon1160/inverted-index). Compile and create a JAR executable.

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
❯ gsutil cp target/pagerank0.0-SNAPSHOT-jar-with-dependencies.jar  "gs://{{BUCKET_NAME}}/pagerank.jar"
```

#### Create and submit job

Create a job following Google Dataproc schema, for example:

```
POST /v2/projects/{{PROJECT_ID}}/regions/{{REGION}}/jobs:submit/
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
        "5"
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

### Join part-r-\*

Join results from Inverted Index and PageRank algorithms into one text file. Go to [output](output) directory and run [join.sh](output/join.sh).
