# ===== SCENARIO 3 =====

set ns [new Simulator]

set tracefile [open logs/s3.tr w]
$ns trace-all $tracefile

set namfile [open visuals/s3.nam w]
$ns namtrace-all-wireless $namfile 800 800

set chan [new Channel/WirelessChannel]

set val(nn) 8
set god_ [create-god $val(nn)]

set topo [new Topography]
$topo load_flatgrid 800 800

$ns node-config -adhocRouting AODV \
 -llType LL \
 -macType Mac/802_11 \
 -ifqType Queue/DropTail/PriQueue \
 -ifqLen 50 \
 -antType Antenna/OmniAntenna \
 -propType Propagation/TwoRayGround \
 -phyType Phy/WirelessPhy \
 -channel $chan \
 -topoInstance $topo \
 -agentTrace ON \
 -routerTrace ON \
 -macTrace ON \
 -namtrace ON \
 -movementTrace ON

$ns color 1 Blue
$ns color 2 Red

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$n0 set X_ 50.0;  $n0 set Y_ 300.0; $n0 set Z_ 0.0; $n0 label "SOURCE"
$n1 set X_ 130.0; $n1 set Y_ 300.0; $n1 set Z_ 0.0; $n1 label "R1"
$n2 set X_ 210.0; $n2 set Y_ 300.0; $n2 set Z_ 0.0; $n2 label "R2"
$n3 set X_ 290.0; $n3 set Y_ 300.0; $n3 set Z_ 0.0; $n3 label "R3"
$n4 set X_ 370.0; $n4 set Y_ 300.0; $n4 set Z_ 0.0; $n4 label "R4"
$n5 set X_ 450.0; $n5 set Y_ 300.0; $n5 set Z_ 0.0; $n5 label "R5"
$n6 set X_ 530.0; $n6 set Y_ 300.0; $n6 set Z_ 0.0; $n6 label "R6"
$n7 set X_ 610.0; $n7 set Y_ 300.0; $n7 set Z_ 0.0; $n7 label "DEST"

foreach n {n0 n1 n2 n3 n4 n5 n6 n7} {
    $ns initial_node_pos [set $n] 30
}

set udp [new Agent/UDP]
$udp set fid_ 1
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n7 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_ 0.02
$cbr attach-agent $udp

$ns at 1.0 "$cbr start"
$ns at 9.0 "$cbr stop"

proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exec nam visuals/s3.nam &
 exit 0
}

$ns at 10.0 "finish"
$ns run
