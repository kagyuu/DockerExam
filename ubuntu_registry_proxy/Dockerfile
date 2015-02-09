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
FROM ubuntu

MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>
 
## Proxy
# ENV http_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
# ENV https_proxy http://foo%40bar.com:password@proxy.bar.com:3124/

## Install nginx
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y nginx openssl expect

# maker nginx interactive mode
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# settings for proxy
run rm /etc/nginx/sites-enabled/default
add site.conf /etc/nginx/sites-enabled/

# create crt files
WORKDIR /tmp
RUN openssl genrsa -out server.key 2048
RUN expect -c "\
  set timeout 20;\
  spawn openssl req -new -key server.key -out server.csr;\
  expect -re \"Country Name.*:\"             ; send \"AU\n\";\
  expect -re \"State or Province Name.*:\"   ; send \"State\n\";\
  expect -re \"Locality Name.*:\"            ; send \"City\n\";\
  expect -re \"Organization Name.*:\"        ; send \"Example Co. LTD\n\";\
  expect -re \"Organizational Unit Name.*:\" ; send \"P.R.\n\";\
  expect -re \"Common Name.*:\"              ; send \"John Doe\n\";\
  expect -re \"Email Address.*:\"            ; send \"john@example.com\n\";\
  expect -re \"A challenge password.*:\"     ; send \"\n\";\
  expect -re \"An optional company name.*:\" ; send \"\n\";\
  expect eof;\
  "
RUN openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt

RUN mkdir /etc/nginx/certificates/
RUN mv server.crt /etc/nginx/certificates/
RUN mv server.key /etc/nginx/certificates/

## EXPOSE
# 5443  : ssl-proxy for docker registry 
EXPOSE 5443
 
## Execute nginx
CMD ["nginx"]
