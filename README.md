# sh4twbox-build-env
Build Environment for sh4twbox (NextVod TV setupbox)

## 1. Enter build environment

You can choose one of 1.1 and 1.2.

### 1.1 Instal STLinux 2.4 in debian/ubuntu

If you don't want pre-built environment, you can follow the instructions in

stlinux24-sh4-glibc/Dockerfile to install build environemnt inside your
debian/ubuntu Linux OS.


### 1.2 Enter docker debian 32 build environment

If you are familiar with docker,

	docker run -it stlinux24-sh4-glibc /bin/bash

Or, just install 'docker' package and run:

	./devel.sh init   # only run at first time
	./devel.sh start  # only run after boot your system
	./devel.sh sh

	# after enter the bash shell, assign terminal environment
        $ export TERM=xterm

If you want to install other package, use root

	./devel.sh root   

## 2. Build uboot (twpda-uboot)

### 2.1 check out source

	git clone https://github.com/dlintw/twpda-uboot
	cd  twpda-uboot

### 2.2 build uboot image for NextVOD

	source st24.sh
	./make.sh

## 3. build kernel (kernel-pdk7105 twpda branch)

### 3.1 check out source

	git clone https://github.com/dlintw/kernel-pdk7105
	cd  kernel-pdk7105
	git checkout twpda

### 3.2 build kernel

	source env24.sh
	./make.sh all

## 4. build 3.4 kernel (pdk7105-3.4 working in progressing)

### 4.1 check out source

	git clone https://github.com/dlintw/pdk7105-3.4
	cd pdk7105-3.4

