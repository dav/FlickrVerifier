# FlickrVerifier

## About

(work in progress)

FlickrVerifier intends to easily let you know which photos on your local drive have already been uploaded to Flickr, and allow you to optionally delete the Flickr-store ones from the local drive.

The idea is to generate an MD5 hash value for every Flickr photo in your account and store in a local lookup table. Then there will be scripts to compare photos in a folder to the table.

## Requirements

- A Flickr Developer API key and secret (put in config.yml)
- [flickraw](https://github.com/hanklords/flickraw)
- activesupport

## To use

1. git clone the repo
1. get yourself a Flickr API key and secret
1. cp config.yml.example config.yml
1. Edit config.yml to include your key and secret
1. run "ruby FlickrVerifier.rb | tee flickr_hashes.csv"
1. copy and paste the generated auth URL into your browser, auth, then copy and paste the key back to the command line input (this will update our config.yml with auth tokens so you won't have to do this step ever again)
1. when the run finishes you'll have a tab delimited csv file with the md5 hashes for your flickr photos
1. _(not ready yet)__ run "ruby LocalVerifier.rb flickr_hashes.csv [dir]" which will compare each file in [dir] to see if it is up on Flickr
1. _(not ready yet)_ use -d to delete local files that are already up on Flickr

## TO DO

- Use a specific local db instead of the csv file
- Smarter re-running (don't re-hash anything) 
- Visual confirmation?