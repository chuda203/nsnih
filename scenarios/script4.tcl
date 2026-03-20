# ===== SCENARIO 4 =====
# Keterangan  : Jam kuliah
# Tipe        : Wired + Wireless (3 AP)
# Jumlah Node : 200 wireless nodes
# Routing     : AODV
# Queue       : DropTail
# Traffic     : TCP
# Rate        : 256 Kbps
# Packet Size : 512 byte
# Noise/Error : 0.001
# Sim Time    : 100 s
# Area        : 1000 x 1000 m

set ns [new Simulator]

set tracefile [open logs/s4.tr w]
$ns trace-all $tracefile

set namfile [open visuals/s4.nam w]
$ns namtrace-all-wireless $namfile 1000 1000

# ---- Topography ----
set topo [new Topography]
$topo load_flatgrid 1000 1000

# Wireless nodes: 200 clients + 3 AP wired nodes = 203 total
set num_wl_nodes 200
set num_total [expr $num_wl_nodes + 3]
set god_ [create-god $num_total]

# ---- Wired backbone link bandwidth and delay ----
set bw_backbone  100Mb
set delay_link   10ms

# ---- Wireless node configuration (with noise/error 0.001) ----
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

# ---- Create 200 wireless nodes ----
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

# ---- Associate wireless nodes to APs (groups of ~67 each) ----
for {set i 0} {$i < 67} {incr i} {
    $wl($i) base-station [AddrParams addr2id [$ap0 node-addr]]
}
for {set i 67} {$i < 134} {incr i} {
    $wl($i) base-station [AddrParams addr2id [$ap1 node-addr]]
}
for {set i 134} {$i < $num_wl_nodes} {incr i} {
    $wl($i) base-station [AddrParams addr2id [$ap2 node-addr]]
}

# ---- TCP Traffic flows (256 Kbps, 512B packets) ----
set tcp0 [new Agent/TCP]
$tcp0 set fid_ 1
$ns attach-agent $wl(0) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $wl(199) $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP]
$tcp1 set fid_ 2
$ns attach-agent $wl(20) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $wl(179) $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$tcp2 set fid_ 3
$ns attach-agent $wl(40) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $wl(159) $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

# ---- Schedule traffic ----
$ns at 1.0  "$ftp0 start"
$ns at 99.0 "$ftp0 stop"
$ns at 2.0  "$ftp1 start"
$ns at 98.0 "$ftp1 stop"
$ns at 3.0  "$ftp2 start"
$ns at 97.0 "$ftp2 stop"

# ---- Finish procedure ----
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam visuals/s4.nam &
    exit 0
}

$ns at 100.0 "finish"
$ns run
