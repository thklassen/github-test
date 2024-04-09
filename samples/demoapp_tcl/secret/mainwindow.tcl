menu .mbar
. configure -menu .mbar
menu .mbar.fl -tearoff 0
.mbar add cascade -menu .mbar.fl -label File -underline 0
.mbar.fl add command -label Exit -command { exit }
wm title . "Sample Application"
wm geometry . 600x400
