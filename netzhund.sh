#!/bin/sh

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

wait