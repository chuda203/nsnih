#!/bin/bash

# Pastikan dijalankan dari root folder
echo -e "Skenario\tPDR\tThroughput\tOverhead" > results/hasil.csv

for i in 1 2 3
do
 echo "Running Scenario $i..."
 ns scenarios/script$i.tcl
 awk -f tools/qos.awk logs/s$i.tr > temp.txt
 echo -e "$i\t$(cat temp.txt)" >> results/hasil.csv
done

rm temp.txt
echo "Selesai! cek results/hasil.csv"
