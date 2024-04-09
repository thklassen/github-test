========================= Goal ======================================

This application prototype is meant to resemble the real application's
architecture. It therefore models the requirements for a mixed C and
Tcl coverage analysis and can be used to test the fitness for the
intended purposes with executable code.

========================= Design ====================================

Internally, the application is made up of several components:

 - The main internal executable 'proto.exe' written in C/C++

 - A convenience shell script wrapper 'proto' launching 'proto.exe'
   with (encrypted) scripts initializing the main GUI.

 - A set of encrypted '*.tclx' scripts. The original plain text files
   can be found in the subdirectory 'secrets/'. The exemplaric
   encryption is a simple one (swapping alphabetic characters) but the
   tool will work with safer algorithms under the assumption that
   decryption is performed by the application internally before
   passing the plain code to the embedded Tcl interpreter.

 - A pair of 'itcl' files defining exemplaric Rect and Point classes.

 - The Tcl interpreter is embedded through the standard 'libtcl*.so'
   DLL. Evaluation of Tcl code is done through the Tcl_Eval() API
   function.

From and end user's point of view the application provides a Tk-based
window containing a

  - menu
  - 2D drawing canvas
  - input fields
  - buttons
  - log view

As as result the application features the main characteristic
requirement: a hybrid C/Tcl applications that will result in both C
and Tcl code being covered during execution.

========================= Build =====================================

1.) Edit 'Makefile' and adjust the TCLINCLUDES and TCLLIBS entries
    at the top of the file to reflect your system's paths.

2.) Issue 'make'.

========================= Run ========================================

Simple execute the

  ./proto

shell script wrapper for standard usage. For extended usage one or
more user scripts can be passed as command line arguments:

  ./proto myscript.tcl

Those will be executed right at startup after the main GUI has been
initialized.

========================= Usage ======================================
Possible ways to add a new rectangle:

 1.) GUI action: press the "Add Rectangle" button after specifying the
 x/y coordinate.

 2.) Interactive console: issue e.g. "add 100 50"

 3.) Command line: Run ./proto sample.tcl where this script file
 contains one or several [add] statements.

If either x or y is negative an error will be logged.

