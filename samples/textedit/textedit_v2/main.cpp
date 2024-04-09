#include "textedit.h"
#include <QApplication>

int main( int argc, char ** argv )
{
#ifdef __COVERAGESCANNER__
   __coveragescanner_install(argv[0]);
#endif
   Q_INIT_RESOURCE(textedit);

   QApplication a( argc, argv );
   TextEdit mw;
   mw.resize( 700, 800 );
   mw.show();
   return a.exec();
}
