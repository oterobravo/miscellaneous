#!/bin/bash
#Extract accession numbers from a file and find the names they correspond to
#Input is the file
#A table can be provided with the -t flag. It must be a two column table with acc numbers
##in the first column and the names in the second column. 
table="FALSE"
remove="FALSE"
while getopts ":t:r" param; do
case "${param}" in
t)
t=$OPTARG
table="TRUE"
;;
r)
remove="TRUE"
;;
\?)
echo "Option not recognized: -$OPTARG"
exit
;;
esac
done

shift $((OPTIND-1))

INPUT="$1"
echo $INPUT

if [ $table == "TRUE" ]
	then 
		echo "Table was provided"
		cp $t $INPUT.table
	else
		echo "Table was not provided"
		#grep -oE "[NZCEU]{2,3}\_[A-Za-z0-9]*" $INPUT | sort -u > names
		#grep -oE "[NCEU]{2}[0-9]*" $INPUT | sort -u > names
                #grep -oE "[NZCEU]{2,3}[\_]{0,1}[A-Za-z0-9]{6,12}" $INPUT | sort -u > names
		grep -oE "[NZEUCFPNHAYJ]{2,4}[0-9]{6,9}" $INPUT | sort -u > names
		#grep -oE "[NZCKL]{2}_[[:alnum:]]*" $INPUT | sort -u | sed "s/NZ_//" > names
                touch names2

		for line in $(seq 1 $(wc -l names | awk '{print $1}'));
			do
				ORGNAME=""
				QUERY=$(head -$line names | tail -1)

				ORGNAME=$(esearch -db nuccore -query $QUERY | esummary | xtract -pattern DocumentSummary -element Organism | head -1) 
				if [ -z "$ORGNAME" ];
				then
					ORGNAME=$(esearch -db assembly -query $QUERY | esummary | xtract -pattern DocumentSummary -element Organism | head -1 )
				fi
				if [ -z "$ORGNAME" ];
				then
					echo "Error: Could not find result for $QUERY"
					echo "files are left as they are, delete names* before running again"
					exit
				fi
				echo $ORGNAME>> names2
				

		done < names

		sed 's#[[:punct:]]##g' names2 | sed 's# #\_#g' > names3
		paste names names3 > $INPUT.table
		rm names*
fi

cp $INPUT $INPUT.2
while read lines;
do
	ACC=$(echo $lines | awk '{print $1}' )
	NAME=$(echo $lines | awk '{$1="";print $0}' )
	sed -i temp "s#$ACC#$NAME#g" $INPUT.2
	rm $INPUT.2temp
	unset ACC
	unset NAME
done < $INPUT.table

if [ $remove == "TRUE" ] 
	then
	rm $INPUT.table
fi
