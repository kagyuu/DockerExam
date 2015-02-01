# FROM             (1)   : base docker image
# MAINTAINER       (1)   :
# RUM <cmd>        (0.n) : Command. You can use both simple command style and
#                          the exec form style ["xx","-y","-z"].
# ADD <src> <dest> (0.n) : Copy files from host to gest
# EXPOSE <port>    (0.n) : Expose port infos for container users. It's not port
#                          forward setting.
# CMD <cmd>        (1)   : Service command.(["/usr/sbin/apachectl","-DFOREGROUND"])
#                          You should use the exec form style ["xx","-y","-z"].
# ENTRYPOINT <cmd> (0.1) : Prefix of service command. ("/usr/sbin/apachectl")
#                          $ docker run -p 8080:80 -d cent6_apache -DFOREGROUND
#                          => call "/usr/sbin/apachectl -DFOREGROUND" on guest.
# ENV <key> <val>  (0.n) :
# VOLUME <dir>     (0.n) : shared directory
# WORKDIR <dir>    (0.1) :
# ONBUILD RUN ...  (0.n) : will execute during child image building (this image is
# ONBUILD ADD ...  (0.n) : specified as FROM).
#
# Each line is commit as layer of Unit FS. Caution, max layer is 127.
 
# Pull base image.
FROM centos:centos6
 
MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>

## Proxy
# ENV http_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
# ENV https_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
 
## Install monit and sshd
RUN rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install passwd openssh openssh-server openssh-clients sudo monit

## Operator user
RUN useradd docker
RUN passwd -f -u docker
RUN usermod -G wheel docker
 
## Setup sudoers
RUN echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

## Set up SSH
RUN mkdir -p /home/docker/.ssh; chown docker /home/docker/.ssh; chmod 700 /home/docker/.ssh
ADD authorized_keys /home/docker/.ssh/authorized_keys
 
RUN chown docker /home/docker/.ssh/authorized_keys
RUN chmod 600 /home/docker/.ssh/authorized_keys

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
 
## Init SSHD
RUN /etc/init.d/sshd start &&\
/etc/init.d/sshd stop
 
## Setup monit
RUN sed -ri 's/use address localhost/use address 0.0.0.0/g' /etc/monit.conf
RUN sed -ri 's/allow localhost/#allow localhost/g' /etc/monit.conf

ADD ssh.conf /etc/monit.d/ssh.conf
 
## Expose ports
## 22   : ssh
## 2812 : monit web console
EXPOSE 22 2812
 
## Execute monit
CMD ["/usr/bin/monit","-I"]

