#!/bin/sh

read OUTPUT_DIR
declare -a IPS PORTS
while read LINE; do
  IFS=':' read -r IP PORT PROTOCOL <<< "$LINE"
  IPS+=("$IP")
  PORTS+=("$PORT")
done < $OUTPUT_DIR/ports.txt
