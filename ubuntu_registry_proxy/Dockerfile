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
RUN apt-get install -y nginx-extras git apache2-utils

# settings for nginx
ADD site.conf /etc/nginx/conf.d/site.conf
ADD docker-registry.conf /etc/nginx/docker-registry.conf
RUN htpasswd -bc /etc/nginx/docker-registry.htpasswd docker password

RUN rm /etc/nginx/sites-enabled/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# put crt files
ADD cert/server-cert.pem /etc/ssl/certs/docker-registry
ADD cert/server-key.pem /etc/ssl/private/docker-registry

EXPOSE 443
CMD ["nginx"]
