FROM 32bit/debian:jessie
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime
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

RUN ln -sf bash /bin/sh
RUN wget -q -O /tmp/1 http://download.stlinux.com/pub/stlinux/2.4/misc/
RUN wget -q -O /tmp/x.rpm http://download.stlinux.com/pub/stlinux/2.4/misc/$(grep rpm /tmp/1|tail -1|awk -F'>' '{print $3}' | awk -F'<' '{print $1}')
RUN rpm -ivh --force-debian /tmp/x.rpm

# 2015/04/14 workaround for stmyum update fail problem
#RUN wget -q -O /tmp/k.rpm http://download.stlinux.com/pub/stlinux/2.4/updates/RPMS/host/stlinux24-host-kernel-source-sh4-2.6.32.61_stm24_0215-215.noarch.rpm \
#  && wget -q -O /tmp/f.rpm http://download.stlinux.com/pub/stlinux/2.4/STLinux/host/stlinux24-host-filesystem-1.0-7.noarch.rpm \
#  && rpm -Uvh /tmp/k.rpm /tmp/f.rpm

#ADD wget -q -O /tmp/install http://download.stlinux.com/pub/stlinux/2.4/install
#RUN bash /tmp/install -u all-sh4-glibc
# cache file puts in /opt/STM/STLinux-2.4/host/var/cache/yum/STLinux_Distribution/packages/

#RUN /opt/STM/STLinux-2.4/host/bin/stmyum update -y
#RUN /opt/STM/STLinux-2.4/host/bin/stmyum clearn dbcache packages
#RUN apt-get clean
#RUN rm -R /tmp/*
