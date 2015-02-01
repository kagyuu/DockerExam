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

ENV TERM dumb

## Add Postgis 2 and PostgigreSQL 9.4 for Ubuntu 14.10 Utopic
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ utopic-pgdg main 9.4" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install language-pack-ja manpages-ja fonts-ipa*

# "--force-yes" because pgsql is beta version
RUN apt-get -y --force-yes install postgis

# make encoding UTF-8 (default is damn SQL_ASCII)
RUN pg_dropcluster --stop 9.4 main
RUN pg_createcluster --start -e UTF-8 9.4 main

# make docker super-use of postgresql
USER postgres

RUN /etc/init.d/postgresql start &&\
    psql -q -d template1 -f /usr/share/postgresql/9.4/contrib/postgis-2.1/postgis.sql &&\
    psql -q -d template1 -f /usr/share/postgresql/9.4/contrib/postgis-2.1/spatial_ref_sys.sql &&\
    psql -q -d template1 -f /usr/share/postgresql/9.4/contrib/postgis-2.1/postgis_comments.sql &&\
    /etc/init.d/postgresql stop

RUN /etc/init.d/postgresql start &&\
    psql -c "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker &&\
    /etc/init.d/postgresql stop

USER root

# allow remote access
RUN sed -ri 's/host    all             all             127.0.0.1\/32            md5/host    all             all             0.0.0.0\/0               md5/g' /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

## MapServer
RUN apt-get -y install apache2 \
    cgi-mapserver mapserver-bin mapserver-doc \
    libgd-tools librsvg2-bin \
    libapache2-mod-mapcache

# enable cgid
RUN a2enmod cgid

## sample data
RUN apt-get -y install unzip wget
WORKDIR /tmp

RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_roads.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_railroads.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_airports.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_ports.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_urban_areas.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_rivers_lake_centerlines.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip

RUN unzip ne_10m_admin_0_countries.zip
RUN unzip ne_10m_populated_places.zip
RUN unzip ne_10m_roads.zip
RUN unzip ne_10m_railroads.zip
RUN unzip ne_10m_airports.zip
RUN unzip ne_10m_urban_areas.zip 
RUN unzip ne_10m_rivers_lake_centerlines.zip
RUN unzip ne_10m_lakes.zip

RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_admin_0_countries.shp COUNTRIES_TABLE        > earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_airports.shp          AIRPORTS_TABLE         >> earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_populated_places.shp  POPULATED_PLACES_TABLE >> earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_roads.shp             ROADS_TABLE            >> earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_railroads.shp         RAILROADS_TABLE        >> earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_urban_areas.shp       URBAN_AREAS_TABLE      >> earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_rivers_lake_centerlines.shp RIVERS_TABLE     >> earth.sql
RUN shp2pgsql -D -i -I -s 4326 -W LATIN1 ne_10m_lakes.shp             LAKES_TABLE            >> earth.sql

RUN /etc/init.d/postgresql start &&\
    su docker -c "psql -d docker -f earth.sql" &&\
    /etc/init.d/postgresql stop

# temporary direcotry to store map graphic files
RUN mkdir /var/www/html/tmp
RUN chown www-data /var/www/html/tmp
RUN chmod 755 /var/www/html/tmp

## Mapcache
RUN apt-get -y --force-yes install git cmake gcc g++ \
apache2-dev \
libpng12-dev libjpeg62-dev libcurl4-gnutls-dev \
libpixman-1-dev \
memcached

RUN git clone git://github.com/mapserver/mapcache.git
RUN cd mapcache &&\
mkdir build &&\
cd build &&\
cmake .. -DWITH_MEMCACHE=1 -DWITH_OGR=0 -DWITH_FCGI=0 -DWITH_GEOS=0 &&\
make &&\
make install

ADD mapcache.conf /etc/apache2/conf-available/mapcache.conf
RUN ln -s /etc/apache2/conf-available/mapcache.conf /etc/apache2/conf-enabled/mapcache.conf
RUN mkdir /opt/mapcache

## Monit
ADD postgresql.conf /etc/monit/conf.d/postgresql.conf
ADD apache2.conf /etc/monit/conf.d/apache2.conf

## Expose ports
# 80 : apache2
# 5432  : postgresql
EXPOSE 80 5432

## VOLUME 
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
