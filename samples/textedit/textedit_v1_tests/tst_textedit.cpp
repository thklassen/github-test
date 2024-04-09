#include "tst_textedit.h"

void TestTextEdit::tst_saveFile()
{
  TextEdit textEdit;
  textEdit.fileName="/";
  QVERIFY( ! textEdit.fileSave() );
}


QTEST_MAIN(TestTextEdit);
