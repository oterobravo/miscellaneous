#!/usr/bin/env bash
#Alejandro Otero-Bravo
#This checks for total, minimum, and maximum length of a multi fasta file. 


#Length of sequences: Min, Max, Median, Average
tail -c +2 $1 | awk -v RS=">" -v FS="\n" -v ORS="\n" -v OFS="" 'NR == 1 {$1=""; l=length($0);  
 totallen+=l; 
 maxlen = l;
 minlen = l;
 }; NR > 1 {$1=""; l=length($0);  
 totallen+=l; 
 if(l > maxlen) maxlen = l;
 if(l < minlen) minlen = l;
 } END {printf "Number of sequences: %s\nTotal characters in sequence: %s\nLongest sequence:  %s\nShortest sequence:  %s\n", FNR, totallen, maxlen, minlen}'

#Unique characters not in titles
printf "Unique characters: "
awk '/>/ {next} { for(i=1;i<=NF;i++)if(!a[$i]++)printf "%s ",$i }' FS="" ORS=" " $1
printf "\n"
