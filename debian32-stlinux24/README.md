# debian32-stlinux24
This image is used for build sh4twbox sources.
This image contains:

* all-sh4-glibc
* all-sh4-uclibc

The total image size is about 6.368GB.
It's Dockerfile(how this image is build) is put in
https://github.com/dlintw/sh4twbox-build-env

## Usage

docker run --rm -it dlin/debian32-stlinux24 /bin/bash

All installed stlinux 2.4 files is put on /opt/STM.
