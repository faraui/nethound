#!/bin/sh

while read line; do
  IFS=':' read -r IP PORT PROTOCOL SERVICE <<< "$line"
  if [[ -z "$SERVICE" ]]; then SERVICE="unknown"; fi
  mkdir -p "$SERVICE"
  echo "$IP" >> "$SERVICE/hosts.txt"
  echo "$IP:$PORT:$PROTOCOL" >> "$SERVICE/ports.txt"
done < formatted-nmap.txt

for dir in */; do
  sort -o "$dir/hosts.txt" -u "$dir/hosts.txt"
  sort -o "$dir/ports.txt" -u "$dir/ports.txt"
done
