FROM jenkins

USER root

RUN apt-get -y update && apt-get -y upgrade

# install gcc g++ gfortran
RUN apt-get -y install build-essential

# install static analysis
RUN apt-get -y install cppcheck libcppunit* gcovr
RUN apt-get -y install doxygen graphviz

# install japanese fonts for many charts on jenkins
RUN apt-get -y install fonts-ipafont

WORKDIR /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/fonts
RUN mkdir fallback
RUN cd fallback && ln -s /usr/share/fonts/opentype/ipafont-gothic/ipag.ttf
RUN cd fallback && ln -s /usr/share/fonts/opentype/ipafont-gothic/ipam.ttf
# RUN cd fallback && pwd && ls -la
WORKDIR /

USER jenkins
