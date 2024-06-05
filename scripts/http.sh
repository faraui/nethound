#!/bin/sh

read SCAN_DIR
declare -a IPS PORTS
while read LINE; do
  IFS=':' read -r IP PORT PROTOCOL <<< "$LINE"
  IPS+=("$IP")
  PORTS+=("$PORT")
done < $SCAN_DIR/ports.txt
