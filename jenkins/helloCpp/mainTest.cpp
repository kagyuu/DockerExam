#include <cppunit/TestResult.h>
#include <cppunit/TestResultCollector.h>
#include <cppunit/BriefTestProgressListener.h>
#include <cppunit/TestRunner.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
#include <cppunit/CompilerOutputter.h>
#include <cppunit/XmlOutputter.h>

using namespace CPPUNIT_NS;

int main(int argc, char **argv) {
    TestResult controller;
    TestResultCollector result;
    controller.addListener(&result);

    BriefTestProgressListener progress;
    controller.addListener(&progress);

    TestRunner runner;
    runner.addTest(TestFactoryRegistry::getRegistry().makeTest());
    runner.run(controller);

    // compiler output
    CompilerOutputter coutputter(&result, stdCOut());
    coutputter.write();

    // output test result for jenkins 
    std::ofstream ofs("test_result.xml");
    CPPUNIT_NS::XmlOutputter outputter(&result, ofs,"UTF-8");
    outputter.write();

    return result.wasSuccessful() ? 0 : 1;
}
