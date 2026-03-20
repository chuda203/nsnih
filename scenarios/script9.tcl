# ===== SCENARIO 9 =====
# Keterangan  : Event kampus
# Tipe        : Wired + Wireless (3 AP)
# Jumlah Node : 250 wireless nodes
# Routing     : AODV
# Queue       : DropTail
# Traffic     : TCP + UDP
# Rate        : 1 Mbps
# Packet Size : 1024 byte
# Noise/Error : 0.005
# Sim Time    : 100 s
# Area        : 1000 x 1000 m

set ns [new Simulator]

set tracefile [open logs/s9.tr w]
$ns trace-all $tracefile

set namfile [open visuals/s9.nam w]
$ns namtrace-all-wireless $namfile 1000 1000

# ---- Topography ----
set topo [new Topography]
$topo load_flatgrid 1000 1000

# Wireless nodes: 250 clients + 3 AP wired nodes = 253 total
set num_wl_nodes 250
set num_total [expr $num_wl_nodes + 3]
set god_ [create-god $num_total]

# ---- Wired backbone link bandwidth and delay ----
set bw_backbone  100Mb
set delay_link   10ms

# ---- Wireless node configuration ----
set chan [new Channel/WirelessChannel]

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
 -movementTrace ON

# ---- Create 250 wireless nodes ----
for {set i 0} {$i < $num_wl_nodes} {incr i} {
    set wl($i) [$ns node]
    $wl($i) random-motion 1
}

# ---- Position wireless nodes in 1000x1000 area ----
for {set i 0} {$i < $num_wl_nodes} {incr i} {
    $wl($i) set X_ [expr {($i * 97 + 50) % 950}]
    $wl($i) set Y_ [expr {($i * 83 + 50) % 950}]
    $wl($i) set Z_ 0.0
    $ns initial_node_pos $wl($i) 20
}

# ---- Switch to wired node config for AP backbone ----
$ns node-config -wiredRouting ON \
                -llType ""       \
                -macType ""      \
                -propType ""     \
                -antType ""      \
                -phyType ""      \
                -channel ""      \
                -agentTrace OFF  \
                -routerTrace OFF \
                -macTrace OFF    \
                -movementTrace OFF \
                -adhocRouting ""

set ap0 [$ns node]
set ap1 [$ns node]
set ap2 [$ns node]

# ---- Wired backbone links between APs ----
$ns duplex-link $ap0 $ap1 $bw_backbone $delay_link DropTail
$ns duplex-link $ap1 $ap2 $bw_backbone $delay_link DropTail

# ---- Associate wireless nodes to APs (~83 each) ----
for {set i 0} {$i < 83} {incr i} {
    $wl($i) base-station [AddrParams addr2id [$ap0 node-addr]]
}
for {set i 83} {$i < 166} {incr i} {
    $wl($i) base-station [AddrParams addr2id [$ap1 node-addr]]
}
for {set i 166} {$i < $num_wl_nodes} {incr i} {
    $wl($i) base-station [AddrParams addr2id [$ap2 node-addr]]
}

# ---- TCP Traffic flows (1 Mbps, 1024B packets) ----
# interval = 1024 / (1000000/8) = 1024 / 131072 = 0.0078125 s
set tcp0 [new Agent/TCP]
$tcp0 set fid_ 1
$ns attach-agent $wl(0) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $wl(249) $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP]
$tcp1 set fid_ 2
$ns attach-agent $wl(25) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $wl(224) $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$tcp2 set fid_ 3
$ns attach-agent $wl(50) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $wl(199) $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

# ---- UDP Traffic flows (1 Mbps, 1024B packets) ----
set udp0 [new Agent/UDP]
$udp0 set fid_ 4
$ns attach-agent $wl(75) $udp0
set null0 [new Agent/Null]
$ns attach-agent $wl(174) $null0
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1024
$cbr0 set interval_   0.0078125
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$udp1 set fid_ 5
$ns attach-agent $wl(100) $udp1
set null1 [new Agent/Null]
$ns attach-agent $wl(149) $null1
$ns connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1024
$cbr1 set interval_   0.0078125
$cbr1 attach-agent $udp1

set udp2 [new Agent/UDP]
$udp2 set fid_ 6
$ns attach-agent $wl(125) $udp2
set null2 [new Agent/Null]
$ns attach-agent $wl(124) $null2
$ns connect $udp2 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 1024
$cbr2 set interval_   0.0078125
$cbr2 attach-agent $udp2

# ---- Schedule traffic ----
$ns at 1.0  "$ftp0 start"
$ns at 99.0 "$ftp0 stop"
$ns at 2.0  "$ftp1 start"
$ns at 98.0 "$ftp1 stop"
$ns at 3.0  "$ftp2 start"
$ns at 97.0 "$ftp2 stop"
$ns at 1.5  "$cbr0 start"
$ns at 99.0 "$cbr0 stop"
$ns at 2.5  "$cbr1 start"
$ns at 98.5 "$cbr1 stop"
$ns at 3.5  "$cbr2 start"
$ns at 97.5 "$cbr2 stop"

# ---- Finish procedure ----
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam visuals/s9.nam &
    exit 0
}

$ns at 100.0 "finish"
$ns run
