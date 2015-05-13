APPNAME=warehouse
APPMAIN=./src/main.cpp
TESTMAIN=warehouseTest
###########################################################################
# Which compiler
CC=g++
FC=g77
###########################################################################
# Where to install
TARGET=./
###########################################################################
# Where are include files kept
LIBS=-lcppunit
INCLUDES=-I./src -I./test
###########################################################################
# Compile option
CFLAGS=-g -Wall -coverage

SRC:=$(filter-out $(APPMAIN),$(wildcard ./src/*.cpp))
TEST:=$(wildcard ./test/*.cpp)
OBJ:=$(SRC:.cpp=.o) $(TEST:.cpp=.o)

###########################################################################
# Control Script
all: clean compile report
clean:
	find ./ -name *.o -exec rm -v {} \;
	find ./ -name *.gcno -exec rm -v {} \;
	find ./ -name *.gcda -exec rm -v {} \;
	-rm $(APPNAME)
	-rm $(TESTMAIN)
	-rm *_result.xml
	-rm doxygen_*
	-rm -rf html
	-rm -rf latex

###########################################################################
# Body
compile: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(TESTMAIN) $(LIBS)

%.o : %.cpp
	$(CC) $(CFLAGS) $(LIBS) $(INCLUDES) -c $< -o $@

report:
	./$(TESTMAIN)
	gcovr --xml --output=gcover_result.xml src/
	cppcheck --enable=all --xml src 2> cppcheck_result.xml
	doxygen doxygen.conf > /dev/null
