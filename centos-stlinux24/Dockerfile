# Sorry, this is out of date and can not build successful anymore.
# Usage
# =====
# # assume /tmp/root is your shared directory with this docker
# # assume 20022 is your ssh port for this docker, password: root
# docker run -d -v /tmp/root:/root -p 20022:22 dlin/centos-stlinux24
# ssh -p 20022 root@localhost

#FROM toopher/centos-i386:centos6
FROM centos
MAINTAINER Daniel YC Lin <dlin.tw at gmail>
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# if want to force use Taiwan mirror
# ref: http://www.phcno1.net/modules/tad_book3/page.php?tbdsn=538

RUN yum update -y

RUN yum install -y git unzip subversion openssh-server \
	gcc-c++ make readline-devel which unzip

RUN yum install -y wget

#RUN wget -O /tmp/fossil.zip http://www.fossil-scm.org/download/fossil-linux-x86-20140127173344.zip
#RUN unzip -d /usr/bin /tmp/fossil.zip

#RUN /etc/init.d/sshd start
RUN echo 'root:root' | chpasswd

#RUN wget -O /tmp/install http://ftp.stlinux.com/pub/stlinux/2.4/install
RUN curl -o /tmp/install http://ftp.stlinux.com/pub/stlinux/2.4/install
RUN bash /tmp/install all-sh4-glibc
# cache file puts in /var/cache/yum/x86_64/6/STLinux_Distribution_Updates/packages/

RUN yum clean packages dbcache
RUN /opt/STM/STLinux-2.4/host/bin/stmyum clean dbcache packages
RUN rm -R /tmp/*

#ENTRYPOINT ["/usr/sbin/sshd", "-D"]
EXPOSE 22
