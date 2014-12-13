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
FROM atsushi/ubuntu_oracle_jdk7

MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>

## Update
RUN apt-get -y update && apt-get -y upgrade

## Install Nexus
RUN apt-get -y install curl
RUN cd /opt &&\
curl -L --progress http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz | tar xz
RUN ln -s /opt/nexus-2.11.0-02/ /opt/nexus
RUN chown -R docker:docker /opt/nexus
RUN chown -R docker:docker /opt/nexus-2.11.0-02
RUN chown -R docker:docker /opt/sonatype-work

ADD nexus.conf /etc/monit/conf.d/nexus.conf

## Expose ports
# 8081 : nexus
EXPOSE 8081

VOLUME ["/opt/nexus","/opt/sonatype-work"]
