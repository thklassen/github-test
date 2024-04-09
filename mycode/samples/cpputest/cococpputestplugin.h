#ifndef COCOCPPUTESTPLUGIN_H
#define COCOCPPUTESTPLUGIN_H

#include "CppUTest/SimpleString.h"
#include "CppUTest/TestPlugin.h"

class CocoCppUtestPlugin : public TestPlugin
{
public:
    CocoCppUtestPlugin(const SimpleString& name = "CocoCppUtestPlugin");

    virtual void preTestAction(UtestShell&, TestResult&);
    virtual void postTestAction(UtestShell&, TestResult&);
};

#endif // COCOCPPUTESTPLUGIN_H
