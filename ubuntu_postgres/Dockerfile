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
FROM atsushi/ubuntu_monit_ssh

MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>

## Add PostgreSQL 9.4 beta2 for Ubuntu 14.10 Utopic
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ utopic-pgdg main 9.4" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get -y update && apt-get -y upgrade
# "--force-yes" because pgsql is beta version
RUN apt-get -y --force-yes install postgresql

# make encoding UTF-8 (default is damn SQL_ASCII)
RUN pg_dropcluster --stop 9.4 main
RUN pg_createcluster --start -e UTF-8 9.4 main

# make docker super-use of postgresql
USER postgres
RUN /etc/init.d/postgresql start &&\
    psql -c "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker &&\
    /etc/init.d/postgresql stop
USER root

# allow remote access
RUN sed -ri 's/host    all             all             127.0.0.1\/32            md5/host    all             all             0.0.0.0\/0               md5/g' /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

## Monit
ADD postgresql.conf /etc/monit/conf.d/postgresql.conf
 
## Expose ports
# 5432  : postgresql
EXPOSE 5432

## VOLUME 
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

