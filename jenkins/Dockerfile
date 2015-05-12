FROM jenkins

USER root

RUN apt-get -y update && apt-get -y upgrade

# install gcc g++ gfortran
RUN apt-get -y install build-essential

# install static analysis
RUN apt-get -y install cppcheck libcppunit* gcovr

USER jenkins

