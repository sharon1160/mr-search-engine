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
