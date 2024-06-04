#!/bin/sh

########
# ncat #
########
declare -a IPS PORTS
while read LINE; do
  IFS=':' read -r IP PORT PROTOCOL <<< "$LINE"
  IPS+=("$IP")
  PORTS+=("$PORT")
done

for i in "${!IPS[@]}"; do
  echo "ncat --verbose --nodns ${IPS[i]} ${PORTS[i]}" >> ncat.txt
  ncat --verbose --nodns ${IPS[i]} ${PORTS[i]} >> ncat.txt 2>&1
done

echo "$(ncat --version 2>&1)

$(sed '/nmap.org/d; s/^/  /g; s/^  ncat/ncat/g' ncat.txt)" > ncat.txt
