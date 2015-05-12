#include "warehouse.h"
#include <cppunit/extensions/HelperMacros.h>

using namespace CPPUNIT_NS;

class warehouseTest : public TestFixture {
    CPPUNIT_TEST_SUITE(warehouseTest);
    CPPUNIT_TEST(test1);
    CPPUNIT_TEST(test2);
    CPPUNIT_TEST_SUITE_END();

    void test1(){
    	Warehouse *w = new Warehouse();
    	w->putGoods(100);
        CPPUNIT_ASSERT( 25 == w->takeGoods(25) );
        CPPUNIT_ASSERT( 75 == w->getStock() );
        delete w;
    }

    void test2(){
    	Warehouse *w = new Warehouse();
    	w->putGoods(100);
        CPPUNIT_ASSERT( 100 == w->takeGoods(1000) );
        CPPUNIT_ASSERT( 0 == w->getStock() );
        delete w;
    }
};

CPPUNIT_TEST_SUITE_REGISTRATION(warehouseTest);
