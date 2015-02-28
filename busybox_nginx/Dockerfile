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
 
FROM progrium/busybox

MAINTAINER Atsushi HONDOH <hondou.atsushi@jp.fujitsu.com>

## Proxy
# ENV http_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
# ENV https_proxy http://foo%40bar.com:password@proxy.bar.com:3124/

RUN mkdir /var/log/nginx
RUN mkdir /var/lib/nginx
RUN opkg-install nginx
RUN sed -ri "s/[ ]+root[ ]+html/root \/var\/www/g" /etc/nginx/nginx.conf
RUN echo "<html><head></head><body>Hello</body></html>" > /var/www/index.html

CMD ["/usr/sbin/nginx","-g","daemon off;"]
VOLUME ["/var/www"]
