# stlinux24-sh4-glibc
This image is used for build sh4twbox sources.
This image contains:

* all-sh4-glibc

The total image size is about 6.8G.
It's Dockerfile(how this image is build) is put in
https://github.com/dlintw/sh4twbox-build-env

## Usage

docker run --rm -it dlin/stlinux24-sh4-glibc /bin/bash

All installed stlinux 2.4 files is put on /opt/STM.
