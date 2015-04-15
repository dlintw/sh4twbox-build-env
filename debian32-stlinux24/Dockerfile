FROM 32bit/debian:jessie
# use GMT+8 as localtime
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# install basic rpm required packages
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
	curl \
	debfoster \
	deborphan \
	python-rpm \
	python-sqlitecachec \
	python-urlgrabber \
	rpm \
	tmux

# use bash instead of sh
RUN ln -sf bash /bin/sh

# get newest depdency rpms
ENV DL http://download.stlinux.com/pub/stlinux/2.4
RUN curl -o /tmp/deps.rpm $DL/misc/$(curl $DL/misc/ \
  | grep rpm |tail -1|awk -F'>' '{print $3}' \
  | awk -F'<' '{print $1}') 
RUN rpm -ivh --force-debian /tmp/deps.rpm


# 2015/04/16 workaround for 'install all-sh4-glibc' script
RUN curl -o /tmp/ks.rpm $DL/updates/RPMS/host/stlinux24-host-kernel-source-sh4-2.6.32.61_stm24_0215-215.noarch.rpm
RUN rpm -Uvh /tmp/ks.rpm

RUN curl -o /tmp/install $DL/install && bash -x /tmp/install -u all-sh4-glibc

RUN curl -o /tmp/ulkh.rpm $DL/STLinux/sh4_uclibc/stlinux24-sh4_uclibc-linux-kernel-headers-2.6.32.10_stm24_0201-42.noarch.rpm
RUN rpm -Uvh /tmp/ulkh.rpm

RUN bash -x /tmp/install -u all-sh4-uclibc
RUN /opt/STM/STLinux-2.4/host/bin/stmyum update -y

# cache file puts in /opt/STM/STLinux-2.4/host/var/cache/yum/STLinux_Distribution/packages/
RUN /opt/STM/STLinux-2.4/host/bin/stmyum clearn dbcache packages
RUN apt-get clean
RUN rm -R /tmp/*
