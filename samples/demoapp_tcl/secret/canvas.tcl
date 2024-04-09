source rect.itcl

pack [canvas .canvas -height 200 -relief raised]

pack [frame .toolbar] -expand yes -fill x

set x 50
set y 50
pack [label .toolbar.xl -text "X:"] -side left
pack [entry .toolbar.x -textvariable x] -side left
pack [label .toolbar.yl -text "Y:"] -side left
pack [entry .toolbar.y -textvariable y] -side left
pack [button .toolbar.add -text "Add Rectangle" -command { add $x $y; log "add $x $y" } ] -side left

proc add { x y } {
    if { $x < 0 || $y < 0 } {
        log "Invalid x/y coordinate"
        return
    }
    set width 50
    set height 50
    set x2 [expr {$x + $width}]
    set y2 [expr {$y + $height}]
    .canvas create rect $x $y $x2 $y2 -fill blue

    # wrap in Rect Itcl object
    return [Rect #auto $x $y $width $height]
}


