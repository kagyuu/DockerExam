# Busybox is ths simplest linux distribution. It's only few Mega Bytes,
# but contains 200 ordinary unix commands. 
FROM busybox
RUN mkdir /var/www/html
RUN echo "<html><body>Hello Docker World!</body></html>" > /var/www/html/index.html
VOLUME /var/www/html
CMD /bin/sh
