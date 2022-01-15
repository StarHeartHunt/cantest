#!/bin/bash

Show_Stat() {
  RXPacketsSum=$(ifconfig can0|awk '/RX.* packets ([0-9])/' | awk '{print $3}')
  RXPacketsLoss=$(ifconfig can0|awk '/RX.* dropped ([0-9])/' | awk '{print $3}')
  TXPacketsSum=$(ifconfig can1|awk '/TX.* packets ([0-9])/' | awk '{print $3}')
  TXPacketsLoss=$(ifconfig can1|awk '/TX.* dropped ([0-9])/' | awk '{print $3}')

  PacketLossRate=$(awk -vrxs=$RXPacketsSum -vrxl=$RXPacketsLoss -vtxs=$TXPacketsSum -vtxl=$TXPacketsLoss 'BEGIN{printf("%.2f%%\n",100-(rxs/txs*100))}')
  #PacketReceiveRate=$(awk -vrxs=$RXPacketsSum -vrxl=$RXPacketsLoss -vtxs=$TXPacketsSum -vtxl=$TXPacketsLoss 'BEGIN{printf("%.2f%%\n",rxs/txs*100)}')
  
  echo "CAN device $1 test report:"
  echo "  Packet loss rate: ${PacketLossRate}"
  echo "  can0 RX packets loss/sum: ${RXPacketsLoss}/${RXPacketsSum}"
  echo "  can1 TX packets loss/sum: ${TXPacketsLoss}/${TXPacketsSum}"
  #printf "\n\n====== Detailed Information ======\n"
  #ifconfig $1
  #exit 0
}

Show_Help() {
  echo "Usage: $0 send/stat ...[parameters]...."
}

Send_CAN() {
  if [[ -z "$2" ]] ; then
    cangen $1
  else
    cangen $1 -g $2
  fi
}

if [[ $# -eq 0 ]] ; then
  Show_Help
  exit 1
fi

case $1 in
"stat")
  if [[ -z "$2" ]] ; then
    echo "Missing can_device!"
    exit 1
  fi
  while :
  do
    Show_Stat $2
    sleep 0.2
    tput cuu1 # move cursor up by one line
    tput el # clear the line
    tput cuu1
    tput el
    tput cuu1
    tput el
    tput cuu1
    tput el
  done
  ;;
"send")
  if [[ -z "$2" ]] ; then
    echo "Missing can_device!"
    exit 1
  fi
  Send_CAN $2 $3
  ;;
"start")
  if [[ -z "$2" ]] ; then
    echo "Missing can_device!"
    exit 1
  fi
  if [[ -z "$3" ]] ; then
    while :
    do
      cansend $2 1ff#0bb80bb80bb80bb8
      cansend $2 200#0bb80bb80bb80bb8
    done
  else
    while :
    do
      cansend $2 $3
    done
  fi
  ;;
*)
  echo "Command not found, choices: [send, stat]"
  exit 1
esac
