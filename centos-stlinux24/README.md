# centos-stlinux24
This image is used for build sh4twbox sources.
This image contains:

* all-sh4-glibc

The total image size is about 4.044GB.
It's Dockerfile(how this image is build) is put in
https://github.com/dlintw/sh4twbox-build-env

## Usage

docker run --rm -it dlin/centos-stlinux24 /bin/bash

All installed stlinux 2.4 files are put on /opt/STM.
