# sh4twbox-build-env
Build Environment for sh4twbox (NextVod TV setupbox)

## 1. Enter build environment

You can choose one of 1.1 and 1.2.

### 1.1 Instal STLinux 2.4 in debian/ubuntu

If you don't want pre-built environment, you can follow the instructions in

stlinux24-sh4-glibc/Dockerfile to install build environemnt inside your
debian/ubuntu Linux OS.


### 1.2 Enter docker debian 32-bit build environment

If you are familiar with docker,

	docker run -it stlinux24-sh4-glibc /bin/bash

Or, just install 'docker' package and run:

	./devel.sh init   # only run at first time
	./devel.sh start  # only run after boot your system
	./devel.sh sh

If you want to install other package, use root

	./devel.sh root   

If you want to pull fresh image,

	./devel.sh rm    # force remove exist container
	./devel.sh init  # rebuild image

The default image for 64-bit environment is base on centos.
And we use debian to build 32-bit environment.
To assign other other image, we could use the IMAGE environment variable::

	export IMAGE=dlin/centos-stlinux24
        devel.sh <options>

## 2. Build sh4twbox

Just one command::

  make 
