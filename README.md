# sh4twbox-build-env
Build Environment for sh4twbox (NextVod TV setupbox)

## Docker Image Usage

docker run --rm -it <image_name> /bin/bash

## build twpda-uboot 

### enter debian 32 build environment
	./devel.sh init
	./devel.sh start
	./devel.sh sh
### check out source
	git clone https://github.com/dlintw/twpda-uboot
	cd  twpda-uboot
### build it
	source st24.sh
	./make.sh
