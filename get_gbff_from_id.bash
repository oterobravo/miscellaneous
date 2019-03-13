#!/usr/bin/env bash
#Extract all gbff files from the assembly database from a TaxID
#input the taxid number for the group

if [ ! -n "$1" ]
then
	echo "Provide a number corresponding to the taxID of interest"
	echo "Usage: get_gbff_from_id.bash id"
	exit 85
fi 

TXID=$1
QUERY="txid$TXID[Organism:exp]"
LISTOUT="$TXID"links.txt
ERROUT="$TXID"err.log

esearch -db assembly -query $QUERY | esummary | xtract -pattern DocumentSummary -element FtpPath_RefSeq | awk -F'/' '{print $0 "/" $10 "_genomic.gbff.gz" }' > $LISTOUT 

wget -w 1 --random-wait -i $LISTOUT 2> $ERROUT
