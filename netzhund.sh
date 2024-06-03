#!/bin/sh

while read line; do
  IFS=':' read -r IP PORT PROTOCOL SERVICE <<< "$line"
  if [[ -z "$SERVICE" ]]; then SERVICE="unknown"; fi
  mkdir -p "$SERVICE"
  echo "$IP" >> "$SERVICE/hosts.txt"
  echo "$IP:$PORT:$PROTOCOL" >> "$SERVICE/ports.txt"
done < formatted-nmap.txt

for SERVICE in */; do
  sort -o "$SERVICE/hosts.txt" -u "$SERVICE/hosts.txt"
  sort -o "$SERVICE/ports.txt" -u "$SERVICE/ports.txt"
  cat "$SERVICE/ports.txt" | /netzhund/scipts/$SERVICE.sh &
done
