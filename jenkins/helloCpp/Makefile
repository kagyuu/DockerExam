CXX=g++
LIBS=-lcppunit
SOURCES=warehouse.cpp
TESTS=warehouseTest.cpp
TARGET=mainTest

all :
	$(CXX) -coverage -o $(TARGET) $(SOURCES) $(TESTS) $(TARGET).cpp $(LIBS)
	./$(TARGET)
	gcovr --xml --output=gcover_result.xml
	cppcheck --enable=all --xml $(SOURCES) 2> cppcheck_result.xml

clean :
	-rm *.gcov
	-rm *.gcno
	-rm *.gcda
	-rm $(TARGET)
	-rm *_result.xml
