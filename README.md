# FlickrVerifier

## About

(work in progress)

FlickrVerifier intends to easily let you know which photos on your local drive have already been uploaded to Flickr, and allow you to optionally delete the Flickr-store ones from the local drive.

The idea is to generate an MD5 hash value for every Flickr photo in your account and store in a local lookup table. Then there will be scripts to compare photos in a folder to the table.

## Requirements

- A Flickr Developer API key and secret (put in config.yml)
- [flickraw](https://github.com/hanklords/flickraw)
