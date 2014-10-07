FROM atsushi/ubuntu_monit_ssh
RUN apt-get -y update && apt-get -y install apache2 php5
ADD apache.conf /etc/monit/conf.d/apache.conf
