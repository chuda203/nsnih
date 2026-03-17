# ===== SCENARIO 1 =====

set ns [new Simulator]

set tracefile [open logs/s1.tr w]
$ns trace-all $tracefile

set namfile [open visuals/s1.nam w]
$ns namtrace-all-wireless $namfile 500 500

set chan [new Channel/WirelessChannel]

set val(nn) 4
set god_ [create-god $val(nn)]

set topo [new Topography]
$topo load_flatgrid 500 500

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

$n0 set X_ 50;  $n0 set Y_ 200; $n0 label "SOURCE"
$n1 set X_ 150; $n1 set Y_ 200; $n1 label "R1"
$n2 set X_ 250; $n2 set Y_ 200; $n2 label "R2"
$n3 set X_ 350; $n3 set Y_ 200; $n3 label "DEST"

foreach n {n0 n1 n2 n3} {
    $ns initial_node_pos [set $n] 30
}

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_ 0.005
$cbr attach-agent $udp

$ns at 1.0 "$cbr start"
$ns at 9.0 "$cbr stop"

# gerakan
$ns at 3.0 "$n1 setdest 150 300 20"

proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exec nam visuals/s1.nam &
 exit 0
}

$ns at 10.0 "finish"
$ns run
