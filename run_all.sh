#!/bin/bash

# Pastikan dijalankan dari root folder
echo -e "Skenario\tDelay\tThroughput\tPacketLoss\tJitter" > results/hasil.csv

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
 echo "Running Scenario $i..."
 ns scenarios/script$i.tcl
 awk -f tools/qos.awk logs/s$i.tr > temp.txt
 echo -e "$i\t$(cat temp.txt)" >> results/hasil.csv
done

rm temp.txt
echo "Selesai! cek results/hasil.csv"
