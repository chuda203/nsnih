BEGIN {
 sent=0; received=0; control=0; bytes=0;
 start=9999; end=0;
}

{
 if ($1=="s" && $4=="AGT") {
  sent++;
  if ($2<start) start=$2;
 }

 if ($1=="r" && $4=="AGT") {
  received++;
  bytes+=$6;
  if ($2>end) end=$2;
 }

 if ($1=="s" && ($4=="RTR" || $7=="AODV")) {
  control++;
 }
}

END {
 duration=end-start;
 pdr=(sent>0)?(received/sent)*100:0;
 thr=(duration>0)?(bytes*8)/(duration*1000):0;
 ovh=(sent>0)?control/sent:0;

 printf("%.2f\t%.2f\t%.2f\n", pdr, thr, ovh);
}
