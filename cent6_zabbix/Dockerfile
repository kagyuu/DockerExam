FROM atsushi/cent6_monit_ssh

###################
## Install zabbix

RUN rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
RUN yum -y update
RUN yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-web-japanese.noarch zabbix-agent

RUN sed -ri 's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server.conf
RUN sed -ri 's/# DBPassword=/DBPassword=zabbixpassword/g' /etc/zabbix/zabbix_server.conf

# Expand zabbix RPM for getting DDLs of zabbix database.
#
# I don't know why 'yum install zabbix-server-mysql' didn't 
# put /usr/share/doc/zabbix-server-mysql/create/*.sql during docker build sequence.
# Oppositely, it goes well in real machine.

RUN yum -y install wget
WORKDIR /tmp
RUN wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-server-mysql-2.4.3-1.el6.x86_64.rpm &&\
 mkdir zabbix-server-mysql &&\
 cd zabbix-server-mysql &&\
 rpm2cpio ../zabbix-server-mysql-2.4.3-1.el6.x86_64.rpm | cpio -id

###################
## Install mysql

RUN yum -y install mysql-server

# set password for mysql root user
RUN /etc/init.d/mysqld start &&\
mysqladmin -u root password 1qazse4 &&\
/etc/init.d/mysqld stop

###################
## create database for zabbix

RUN /etc/init.d/mysqld start &&\
mysql -u root --password=1qazse4 -e "create database zabbix character set utf8 collate utf8_bin;" &&\
mysql -u root --password=1qazse4 -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbixpassword'; flush privileges;" &&\
/etc/init.d/mysqld stop

# insert initial data
RUN /etc/init.d/mysqld start &&\
cd /tmp/zabbix-server-mysql/usr/share/doc/zabbix-server-mysql-2.4.3/create &&\
mysql -u zabbix --password=zabbixpassword zabbix < schema.sql &&\
mysql -u zabbix --password=zabbixpassword zabbix < images.sql &&\
mysql -u zabbix --password=zabbixpassword zabbix < data.sql &&\
/etc/init.d/mysqld stop

###################
## Setting PHP

RUN sed -ri 's/;date.timezone =/date.timezone = Asia\/Tokyo/g' /etc/php.ini

###################
## Monit
ADD apache.conf /etc/monit.d/apache.conf
ADD mysql.conf /etc/monit.d/mysql.conf
ADD zabbix.conf /etc/monit.d/zabbix.conf

###################
## Expose ports
## 80 : Zabbix web console
## 10051 : Zabbix
EXPOSE 80 10051

###################
## Volumes
# /etc/zabbix : setteings for zabbix
# /var/lib/mysql : mysql data direcoty

VOLUME ["/etc/zabbix","/var/lib/mysql"]

