#!/bin/sh

declare -a IPS PORTS
while read LINE; do
  IFS=':' read -r IP PORT PROTOCOL <<< "$LINE"
  IPS+=("$IP")
  PORTS+=("$PORT")
done

for i in "${!IPS[@]}"; do
  echo "nc -vn ${IPS[i]} ${PORTS[i]}" >> netcat.txt
  nc -vn ${IPS[i]} ${PORTS[i]} >> netcat.txt 2>&1
done

echo "$(head -n 2 netcat.txt | tail -n 1)

$(sed 's/Ncat://g; /nmap.org/d; s/^/^  /g; s/^  nc -vn/^nc -vn' netcat.txt)" > netcat.txt
