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
FROM atsushi/ubuntu_glassfish41

# Create Datasource
# cf. https://docs.oracle.com/cd/E19879-01/820-7432/gicbh/index.html
RUN ./asadmin start-domain &&\
  ./asadmin create-jdbc-connection-pool \
    --user admin --passwordfile ./passwordfile \
    --datasourceclassname org.postgresql.ds.PGPoolingDataSource \
    --restype javax.sql.DataSource \
    --property user=docker:password=docker:url="jdbc\:postgresql\://localhost\:5432/?loginTimeout\=0&socketTimeout\=0&prepareThreshold\=5&unknownLength\=2147483647&tcpKeepAlive\=false&binaryTransfer\=true&disableColumnSanitiser\=false" \
    testdb-pgsql-pool &&\
  ./asadmin create-jdbc-resource \
    --user admin --passwordfile ./passwordfile \
    --connectionpoolid testdb-pgsql-pool \
    jdbc/testdb &&\
  ./asadmin stop-domain

