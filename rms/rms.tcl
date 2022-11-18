proc rms {xs ys} {
    if {[llength $xs] != [llength $ys]} {
        return -code error "dimension mismatch"
    }
    set area 0.0
    for {set i 1} {$i < [llength $xs]} {incr i} {
        set x1 [lindex $xs [expr {$i-1}]]
        set y1 [lindex $ys [expr {$i-1}]]
        set x2 [lindex $xs $i]
        set y2 [lindex $ys $i]
        set dx [expr {$x2 - $x1}]
        set dy [expr {$y2 - $y1}]
        set area [expr {$area + $dx*($dy**2/3.0 + $y1*$y2)}]
    }
    return [expr {sqrt($area/([lindex $xs end] - [lindex $xs 0]))}]
}




# Create sine wave
set N 1000001
set freq 1000
set tstop [expr 1/double($freq)]
set dt [expr $tstop/double($N-1)]
set xs {}
set ys {}
set pi [expr acos(-1)]
for {set i 0} {$i < $N} {incr i} {
    set t [expr {$dt*$i}]
    lappend xs $t
    lappend ys [expr {sin(2*$pi*$freq*$t)}]
}

# Run benchmark
set trials 38
set t1 [clock microseconds]
for {set i 0} {$i < $trials} {incr i} {
    set val [rms $xs $ys]
}
set t2 [clock microseconds]
set ns [expr {round(10*($t2 - $t1)*1e-6/double($trials)/double($N)*1e9)/10.0}]
set ver [info patchlevel]
puts "TCL    $ver    for           rms = $val : $ns ns per iteration average over   $trials trials of $N points"