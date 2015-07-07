UBOOT_SRC=https://github.com/dlintw/twpda-uboot
KERNEL_SRC=https://github.com/dlintw/twpda-uboot
UBOOT_BIN=uboot/uboot_update_tool/iptvubootupdate.bin
KERNEL_BIN=kernel/arch/sh/boot/uImage.gz
BUSYBOX_VER=1.23.2
BUSYBOX_SRC=http://www.busybox.net/downloads/busybox-$(BUSYBOX_VER).tar.bz2
BUILDROOT_VER=2015.05
BUILDROOT_SRC=http://buildroot.uclibc.org/downloads/buildroot-$(BUILDROOT_VER).tar.bz2
JOBS=$(shell grep -c ^processor /proc/cpuinfo)

# kernel/lib/modules

# setup environment for STLinux 2.4 cross compiler
all: PATH:=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:\
/opt/STM/STLinux-2.4/host/bin:/opt/STM/STLinux-2.4/devkit/sh4/bin

#all: uboot.make kernel.make buildroot.make busybox.make
all: uboot.make kernel.make buildroot.make
buildroot.dir:
	[[ ! -d buildroot ]] \
	&& wget -c $(BUILDROOT_SRC) \
	&& tar xf buildroot-$(BUILDROOT_VER).tar.bz2 \
	&& ln -s buildroot-$(BUILDROOT_VER) buildroot \
	|| true
	touch buildroot.dir

buildroot.make: LD_LIBRARY_PATH=
buildroot.make: buildroot.dir
	cp patches/buildroot.config buildroot/.config \
	&& cd buildroot \
	&& make oldconfig \
	&& make
	false
uboot.dir:
	[[ ! -d uboot ]] && git clone ${UBOOT_SRC} uboot \
		|| true
	touch uboot.dir
uboot.make: uboot.dir
	cd uboot ; ./make.sh
	touch uboot.make
kernel.dir:
	[[ ! -d kernel ]] && git clone ${KERNEL_SRC} kernel \
		&& git checkout twpda || true
	touch kernel.dir
kernel.make: kernel.dir
	cd kernel ; ./make.sh all
	touch kernel.make
busybox.dir:
	if [[ ! -d busybox ]] ; then \
       	  curl -o busybox.tar.bz2 ${BUSYBOX_SRC} \
	  && tar xf busybox.tar.bz2 \
	  && rm -f busybox \
	  && ln -s busybox-$(BUSYBOX_VER) busybox \
	  && cp patches/busybox.config busybox/.config ; \
	fi
	touch busybox.dir
busybox.make: busybox.dir
	cd busybox && make oldconfig && LD_LIBRARY_PATH= make -j $(JOBS) \
	touch busybox.make
	fakeroot <<EOT
	make install
	chmod u+s _install/bin/busybox
	tar -C _install -cJf busybox.txz .
	EOT

clean:
	cd uboot ; ./clean.sh || true
	rm -f uboot.make
	cd kernel ; ./clean.sh || true
	rm -f kernel.make
	cd busybox ; make clean || true
	rm -f busybox.make
