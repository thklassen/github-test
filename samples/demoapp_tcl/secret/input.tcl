pack [frame .history] -expand yes -fill both

text .history.t -yscrollcommand ".history.scroll set" \
        -width 40 -height 6 -wrap word
scrollbar .history.scroll -command ".t yview"

pack .history.scroll -side right -fill y
pack .history.t -expand yes -fill both


set cmd ""

label .l -text "Command:"
entry .e -width 40 -relief sunken -bd 2 -textvariable cmd
focus .e
button .b -text "Execute" -command { executeCommand }
bind .e <Return> { executeCommand }

pack .l -side left
pack .e -side left -expand 1 -fill x
pack .b -side left

proc log { txt } {
    .history.t insert end "$txt\n"
}

proc executeCommand { } {
    upvar 1 cmd globalCmd
    if { [string length $globalCmd] } {
        if { [catch {eval $globalCmd} err] } {
            log $err
        } else {
            log $globalCmd
        }
        set globalCmd ""
    }
}