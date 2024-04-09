#ifndef TST_TEXTEDIT_H
#define TST_TEXTEDIT_H

#include "testcoverageobject.h"
#include "../textedit_v1/textedit.h"
#include <QtTest/QtTest>

class TestTextEdit : public TestCoverageObject
{
Q_OBJECT
  public:
  private slots:
    void tst_saveFile();

  private:
};

#endif
