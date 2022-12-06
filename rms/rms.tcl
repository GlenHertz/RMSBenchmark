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

# generate a 1kHz sine wave from 0 to 1 second (1M+1 points):
set xs {}
set ys {}
set N 1000000
for {set i 0} {$i <= $N} {incr i} {
    set t [expr $i/double($N)]
    lappend xs $t
    lappend ys [expr {sin(2*acos(-1)*1000*$t)}]
}
set val [rms $xs $ys]

# Run benchmark
set trials 4
set t1 [clock microseconds]
for {set i 0} {$i < $trials} {incr i} {
    set val [rms $xs $ys]
}
set N [llength $xs]
set t2 [clock microseconds]
set ns [expr {round(10*($t2 - $t1)*1e-6/double($trials)/double($N)*1e9)/10.0}]
set ver [info patchlevel]
puts "TCL    $ver    for           rms = $val : $ns ns per iteration average over   $trials trials of $N points"