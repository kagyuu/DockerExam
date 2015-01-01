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
FROM atsushi/ubuntu_oracle_jdk8

MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install wget unzip expect

## Install Glassfish
RUN wget http://dlc.sun.com.edgesuite.net/glassfish/4.1/release/glassfish-4.1.zip -P /tmp 
RUN unzip /tmp/glassfish-4.1.zip -d /opt

WORKDIR /opt/glassfish4/bin

# Install the start/stop scripts for Glassfish
RUN ./asadmin create-service

# Change the empty admin password to "1qazse4"
RUN ./asadmin start-domain &&\
  expect -c "\
    set timeout 20;\
    spawn ./asadmin --user admin change-admin-password;\
    expect \"Enter the admin password> \"          ; send \"\r\";\
    expect \"Enter the new admin password> \"      ; send \"1qazse4\r\";\
    expect \"Enter the new admin password again> \"; send \"1qazse4\r\";\
    expect eof;\
  " &&\
  ./asadmin stop-domain


# Enable admin console via web interface form remote PCs.
RUN ./asadmin start-domain &&\
  expect -c "\
    set timeout 20;\
    spawn ./asadmin enable-secure-admin;\
    expect \"Enter admin user name>  \"; send \"admin\r\";\
    expect \"Enter admin password for user \\"admin\\">  \"; send \"1qazse4\r\";\
    expect eof;\
  " &&\
  ./asadmin stop-domain

# Postgresql JDBC Driver
RUN wget http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar -P /tmp
RUN mv /tmp/postgresql-9.3-1102.jdbc41.jar /opt/glassfish4/glassfish/domains/domain1/lib/ext

# Ambassador
RUN apt-get -y install socat daemon

# MEMO: To get the MySQL Connector/J needs an Oracle web account.
 
ADD glassfish.conf /etc/monit/conf.d/glassfish.conf
ADD socat_pgsql /etc/init.d/socat_pgsql
RUN chmod +x /etc/init.d/socat_pgsql
ADD socat_pgsql.conf /etc/monit/conf.d/socat_pgsql.conf

## Expose ports
# 4848 : glassfish Management Console
# 8080 : glassfish
EXPOSE 4848 8080

VOLUME ["/opt/glassfish4/glassfish/domains/domain1/"]
