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
  echo "\$ ncat --verbose --nodns ${IPS[i]} ${PORTS[i]}" >> ncat.txt
  ncat --verbose --nodns ${IPS[i]} ${PORTS[i]} >> ncat.txt 2>&1
done

echo "$(ncat --version 2>&1)
$(sed '/Ncat: [VC]/d; s/^/  /g; s/^  \$/\n\$/g' $SCAN_DIR/ncat.txt)" > $SCAN_DIR/ncat.txt

###############
# ssh-keyscan #
###############
echo "ssh-keyscan by David Mazieres <dm@lcs.mit.edu> and Wayne Davison <wayned@users.sourceforge.net>" > $SCAN_DIR/ssh-keyscan.txt
for i in "${!IPS[@]}"; do
  echo "
\$ ssh-keyscan -p ${PORTS[i]} -T 10 -t dsa,ecdsa,rsa,ed25519 ${IPS[i]}" >> $SCAN_DIR/ssh-keyscan.txt
  ssh-keyscan -p ${PORTS[i]} -T 10 -t dsa,ecdsa,rsa,ed25519 ${IPS[i]} 2>/dev/null | sed 's/^.*ssh-/  /g' >> $SCAN_DIR/ssh-keyscan.txt
done
