#!/bin/sh

#Create file structure
mkdir -p srv/{nmap,services}
cd srv

#Initial nmap scans
nmap -sT -iL hosts.txt --top-ports=1000 -oA nmap/tcp -T2
sudo nmap -sU -iL hosts.txt --top-ports=1000 -oA nmap/udp -T2

#Create directories for services

#date -I
SCAN_NAME=LOL

while read LINE; do
  IFS=':' read -r IP PORT PROTOCOL SERVICE <<< "$LINE"
  if [[ -z "$SERVICE" ]]; then SERVICE="unknown"; fi
  mkdir -p "$SERVICE"
  echo "$IP" >> "$SERVICE/hosts.txt"
  echo "$IP:$PORT:$PROTOCOL" >> "scans/$SCAN_NAME/$SERVICE/ports.txt"
done < formatted-nmap.txt

for SERVICE in */; do
  sort -o "scans/$SCAN_NAME/$SERVICE/hosts.txt" -u "scans/$SCAN_NAME/$SERVICE/hosts.txt"
  sort -o "scans/$SCAN_NAME/$SERVICE/ports.txt" -u "scans/$SCAN_NAME/$SERVICE/ports.txt"
  cat "$SERVICE/ports.txt" | ./scripts/$SERVICE.sh &
done

#Nmap srv script
nmap -sT -sU -sV -sC -iL hosts.txt -pT:$(cat ports-tcp.txt)U:$(cat ports-udp.txt) -oA nmap/all -T2

wait
