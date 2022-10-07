#!/bin/bash

touch invertedindex.txt
touch pagerank.txt

for file in inverted-index/part-r-*
do
  cat ${file} >> invertedindex.txt
done

for file in pagerank/part-r-*
do
  cat ${file} >> pagerank.txt
done
