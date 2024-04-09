package require tcltest
namespace import ::tcltest::*

set rect [add 10 20]

test rect_getX {} -body {
    $rect getX
} -result 10
 
test rect_area {} -body {
    $rect area
} -result 2500

# disabled to provoke missing coverage
#test rect_getTopLeft_X {} -body {
#    set tl [$rect getTopLeft]
#    $tl getX
#} -result 50

cleanupTests

