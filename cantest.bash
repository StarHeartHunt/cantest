#!/bin/bash

Show_Stat() {
  RXPacketsSum=$(ifconfig can0|awk '/RX.* packets ([0-9])/' | awk '{print $3}')
  TXPacketsSum=$(ifconfig can0|awk '/TX.* packets ([0-9])/' | awk '{print $3}')
  RXPacketsLoss=$(ifconfig can0|awk '/RX.* dropped ([0-9])/' | awk '{print $3}')
  TXPacketsLoss=$(ifconfig can0|awk '/TX.* dropped ([0-9])/' | awk '{print $3}')

  RXPacketsLossRate=$(( 100 * RXPacketsLoss / RXPacketsSum + (1000 * RXPacketsLoss / RXPacketsSum % 10 >= 5 ? 1 : 0) ))
  TXPacketsLossRate=$(( 100 * TXPacketsLoss / TXPacketsSum + (1000 * TXPacketsLoss / TXPacketsSum % 10 >= 5 ? 1 : 0) ))
  
  echo "CAN device $1 test report:"
  echo "  RX packets loss/sum: ${RXPacketsLoss}/${RXPacketsSum}=${RXPacketsLossRate}%"
  echo "  TX packets loss/sum: ${TXPacketsLoss}/${TXPacketsSum}=${TXPacketsLossRate}%"
  #printf "\n\n====== Detailed Information ======\n"
  #ifconfig $1
  exit 0
}

Show_Help() {
  echo "Usage: $0 send/stat ...[parameters]...."
}

Send_CAN() {
  cangen $1
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
  Show_Stat $2
  ;;
"send")
  if [[ -z "$2" ]] ; then
    echo "Missing can_device!"
    exit 1
  fi
  Send_CAN $2
  ;;
*)
  echo "Command not found, choices: [send, stat]"
  exit 1
esac
