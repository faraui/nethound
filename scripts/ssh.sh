#!/bin/sh

read SCAN_DIR
declare -a IPS PORTS
while read LINE; do
  IFS=':' read -r IP PORT PROTOCOL <<< "$LINE"
  IPS+=("$IP")
  PORTS+=("$PORT")
done < $SCAN_DIR/ports.txt

########
# ncat #
########
for i in "${!IPS[@]}"; do
  echo "ncat --verbose --nodns ${IPS[i]} ${PORTS[i]}" >> $SCAN_DIR/ncat.txt
  ncat --verbose --nodns ${IPS[i]} ${PORTS[i]} >> $SCAN_DIR/ncat.txt 2>&1
done

echo "$(ncat --version 2>&1)
$(sed '/Ncat: [VC]/d; s/^/  /g; s/^  ncat/\nncat/g' $SCAN_DIR/ncat.txt)" > $SCAN_DIR/ncat.txt

########
# ???? #
########
