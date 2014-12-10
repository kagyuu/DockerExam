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
FROM ubuntu:14.10

MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>
 
## Proxy
# ENV http_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
# ENV https_proxy http://foo%40bar.com:password@proxy.bar.com:3124/

## Install ssh and monit
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y openssh-server rsyslog monit

# Initialize sshd
RUN /etc/init.d/ssh start && /etc/init.d/ssh stop

# Permit only pubkey access
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd && chmod 755 /var/run/sshd

## Operator user
RUN addgroup wheel
RUN useradd -m -G wheel -s /bin/bash docker
RUN echo docker:password | chpasswd

# Setup sudoers
RUN echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
 
# Setup SSH
RUN mkdir /home/docker/.ssh
ADD authorized_keys /home/docker/.ssh/authorized_keys
RUN chown -R docker:docker /home/docker/.ssh/
RUN chmod 701 /home/docker
RUN chmod 700 /home/docker/.ssh
RUN chmod 600 /home/docker/.ssh/authorized_keys

## Setup Monit
ADD monit.conf /etc/monit/conf.d/monit.conf
ADD ssh.conf /etc/monit/conf.d/ssh.conf
ADD rsyslog.conf /etc/monit/conf.d/rsyslog.conf
 
## Expose ports
# 22    : ssh
# 2812  : monit
EXPOSE 22 2812
 
## Execute monit
CMD ["/usr/bin/monit","-I"]
