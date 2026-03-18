# ===== SCENARIO 7 =====

set ns [new Simulator]

set tracefile [open logs/s7.tr w]
$ns trace-all $tracefile

set namfile [open visuals/s7.nam w]
$ns namtrace-all-wireless $namfile 1000 800

set chan [new Channel/WirelessChannel]

set val(nn) 8
set god_ [create-god $val(nn)]

set topo [new Topography]
$topo load_flatgrid 1000 800

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
$ns color 3 Green
$ns color 4 Yellow

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$n0 set X_ 50; $n0 set Y_ 200; $n0 set Z_ 0.0; $n0 label "S"
$n1 set X_ 150; $n1 set Y_ 200; $n1 set Z_ 0.0; $n1 label "R1"
$n2 set X_ 250; $n2 set Y_ 200; $n2 set Z_ 0.0; $n2 label "R2"
$n3 set X_ 350; $n3 set Y_ 200; $n3 set Z_ 0.0; $n3 label "R3"
$n4 set X_ 450; $n4 set Y_ 200; $n4 set Z_ 0.0; $n4 label "R4"
$n5 set X_ 550; $n5 set Y_ 200; $n5 set Z_ 0.0; $n5 label "R5"
$n6 set X_ 650; $n6 set Y_ 200; $n6 set Z_ 0.0; $n6 label "R6"
$n7 set X_ 750; $n7 set Y_ 200; $n7 set Z_ 0.0; $n7 label "D"

foreach n {n0 n1 n2 n3 n4 n5 n6 n7} {
    $ns initial_node_pos [set $n] 30
}

set udp0 [new Agent/UDP]
$udp0 set fid_ 1
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n7 $null0
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.01
$cbr0 attach-agent $udp0
$ns at 1.0 "$cbr0 start"
$ns at 9.0 "$cbr0 stop"


proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exec nam visuals/s7.nam &
 exit 0
}

$ns at 10.0 "finish"
$ns run
