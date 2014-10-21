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

## Proxy
# ENV http_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
# ENV https_proxy http://foo%40bar.com:password@proxy.bar.com:3124/
MAINTAINER Atsushi HONDOH <kagyuu@hondou.homedns.org>
 
ENV TERM dumb 

## 0. Install ssh and monit

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y openssh-server monit

RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd && chmod 755 /var/run/sshd

# Operator user
RUN addgroup wheel
RUN useradd -m -G wheel -s /bin/bash docker
RUN echo docker:password | chpasswd

# Setup sudoers
RUN echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
 
# Setup SSH
RUN mkdir /home/docker/.ssh
ADD authorized_keys /home/docker/.ssh/authorized_keys
RUN chown -R docker:docker /home/docker/.ssh/
RUN chmod 701 /home/docker
RUN chmod 700 /home/docker/.ssh
RUN chmod 600 /home/docker/.ssh/authorized_keys

# root
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod -R g-rwx,o-rwx /root/.ssh

# Setup Monit
ADD monit.conf /etc/monit/conf.d/monit.conf
ADD ssh.conf /etc/monit/conf.d/ssh.conf

## 1. Packages / Dependencies

# run as root!
# RUN apt-get update -y
# RUN apt-get upgrade -y
RUN apt-get install -y sudo \
vim \
build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate python-docutils pkg-config cmake \
git-core \
postfix

RUN update-alternatives --set editor /usr/bin/vim.basic

## 2. Ruby

RUN sudo apt-get remove ruby*

RUN mkdir /tmp/ruby && cd /tmp/ruby &&\
curl -L --progress http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz | tar xz &&\
cd ruby-2.1.2 &&\
./configure --disable-install-rdoc &&\
make &&\
make install

RUN gem install bundler --no-ri --no-rdoc

## 3. System Users

RUN adduser --disabled-login --gecos 'GitLab' git

## 4. Database

# Install the database packages
RUN apt-get install -y postgresql postgresql-client libpq-dev

RUN /etc/init.d/postgresql start &&\
sudo -u postgres psql -d template1 -c "CREATE USER git CREATEDB;" &&\
sudo -u postgres psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER git;" &&\
/etc/init.d/postgresql stop

## 5. Redis

RUN apt-get install redis-server

# Configure redis to use sockets
RUN cp /etc/redis/redis.conf /etc/redis/redis.conf.orig
RUN sed -e 's/^# unixsocket /unixsocket /' -e 's/^port .*/port 0/' /etc/redis/redis.conf.orig | tee /etc/redis/redis.conf

# Activate the changes to redis.conf
RUN /etc/init.d/redis-server start &&\
/etc/init.d/redis-server stop

# Add git to the redis group
RUN usermod -aG redis git

## 6. GitLab

# We'll install GitLab into home directory of the user "git"

## Proxy
# RUN git config --global http.proxy http://foo%40bar.com:password@proxy.bar.com:3124/
# RUN git config --global https.proxy http://foo%40bar.com:password@proxy.bar.com:3124/

WORKDIR /home/git
USER git
RUN git clone https://gitlab.com/gitlab-org/gitlab-ce.git -b 7-3-stable gitlab

# Go to GitLab installation folder
WORKDIR /home/git/gitlab

# Copy the example GitLab config
RUN cp config/gitlab.yml.example config/gitlab.yml

# Make sure GitLab can write to the log/ and tmp/ directories
RUN chown -R git log/
RUN chown -R git tmp/
RUN chmod -R u+rwX log/
RUN chmod -R u+rwX tmp/

# Create directory for satellites
RUN mkdir /home/git/gitlab-satellites
RUN chmod u+rwx,g=rx,o-rwx /home/git/gitlab-satellites

# Make sure GitLab can write to the tmp/pids/ and tmp/sockets/ directories
RUN chmod -R u+rwX tmp/pids/
RUN chmod -R u+rwX tmp/sockets/

# Make sure GitLab can write to the public/uploads/ directory
RUN chmod -R u+rwX  public/uploads

# Copy the example Unicorn config
RUN cp config/unicorn.rb.example config/unicorn.rb

# Find number of cores
RUN nproc

# Copy the example Rack attack config
RUN cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb

# Configure Redis connection settings
RUN cp config/resque.yml.example config/resque.yml

# PostgreSQL
RUN cp config/database.yml.postgresql config/database.yml
RUN chmod o-rwx config/database.yml

# Install Gems
RUN bundle install --deployment --without development test mysql aws

RUN bundle exec rake gitlab:shell:install[v2.0.0] REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production

USER root

# Configure Git global settings for git user, useful when editing via web
# Edit user.email according to what is set in gitlab.yml

RUN git config --global user.name "GitLab"
RUN git config --global user.email "example@example.com"
RUN git config --global core.autocrlf input

RUN /etc/init.d/postgresql start &&\
 /etc/init.d/redis-server start &&\
 echo "yes" | sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production GITLAB_ROOT_PASSWORD=5iveL!fe &&\
 /etc/init.d/redis-server stop &&\
 /etc/init.d/postgresql stop

# Install Init Script
RUN cp lib/support/init.d/gitlab /etc/init.d/gitlab

# Setup Logrotate
RUN cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

# Check Application Status
# Compile Assets
RUN /etc/init.d/postgresql start &&\
 /etc/init.d/redis-server start &&\
 sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production &&\
 sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production &&\
 /etc/init.d/redis-server stop &&\
 /etc/init.d/postgresql stop

## 7. Nginx

RUN apt-get install -y nginx

RUN cp lib/support/nginx/gitlab /etc/nginx/sites-available/gitlab
RUN ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab
RUN rm /etc/nginx/sites-enabled/default

## init scripts
ADD gitlab.conf /etc/monit/conf.d/gitlab.conf
ADD nginx.conf /etc/monit/conf.d/nginx.conf
ADD postfix.conf /etc/monit/conf.d/poxtfix.conf
ADD postgresql.conf /etc/monit/conf.d/postgresql.conf
ADD redis.conf /etc/monit/conf.d/redis.conf

## Expose ports
# 2812  : monit
# 80 : nginx (gitlab)
# 22 : ssh
EXPOSE 22 80 2812

## Execute monit
CMD ["/usr/bin/monit","-I"]
