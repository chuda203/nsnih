# ===== SCENARIO 11 =====

set ns [new Simulator]

set tracefile [open logs/s11.tr w]
$ns trace-all $tracefile

set namfile [open visuals/s11.nam w]
$ns namtrace-all-wireless $namfile 800 800

set chan [new Channel/WirelessChannel]

set val(nn) 6
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
$ns color 3 Green
$ns color 4 Yellow

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 set X_ 100; $n0 set Y_ 100; $n0 set Z_ 0.0; $n0 label "S1"
$n1 set X_ 400; $n1 set Y_ 100; $n1 set Z_ 0.0; $n1 label "D1"
$n2 set X_ 100; $n2 set Y_ 200; $n2 set Z_ 0.0; $n2 label "S2"
$n3 set X_ 400; $n3 set Y_ 200; $n3 set Z_ 0.0; $n3 label "D2"
$n4 set X_ 100; $n4 set Y_ 300; $n4 set Z_ 0.0; $n4 label "S3"
$n5 set X_ 400; $n5 set Y_ 300; $n5 set Z_ 0.0; $n5 label "D3"

foreach n {n0 n1 n2 n3 n4 n5} {
    $ns initial_node_pos [set $n] 30
}

set udp0 [new Agent/UDP]
$udp0 set fid_ 1
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.01
$cbr0 attach-agent $udp0
$ns at 1.0 "$cbr0 start"
$ns at 9.0 "$cbr0 stop"

set udp1 [new Agent/UDP]
$udp1 set fid_ 2
$ns attach-agent $n2 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1
$ns connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 512
$cbr1 set interval_ 0.01
$cbr1 attach-agent $udp1
$ns at 1.0 "$cbr1 start"
$ns at 9.0 "$cbr1 stop"

set udp2 [new Agent/UDP]
$udp2 set fid_ 3
$ns attach-agent $n4 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n5 $null2
$ns connect $udp2 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ 0.01
$cbr2 attach-agent $udp2
$ns at 1.0 "$cbr2 start"
$ns at 9.0 "$cbr2 stop"


proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exec nam visuals/s11.nam &
 exit 0
}

$ns at 10.0 "finish"
$ns run
