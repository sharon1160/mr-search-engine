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
