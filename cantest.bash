#!/bin/bash

Show_Stat() {
  RXPacketsSum=$(ifconfig can0|awk '/RX.* packets ([0-9])/' | awk '{print $3}')
  TXPacketsSum=$(ifconfig can0|awk '/TX.* packets ([0-9])/' | awk '{print $3}')
  RXPacketsLoss=$(ifconfig can0|awk '/RX.* dropped ([0-9])/' | awk '{print $3}')
  TXPacketsLoss=$(ifconfig can0|awk '/TX.* dropped ([0-9])/' | awk '{print $3}')

  if [ $RXPacketsSum == 0 ]
  then
    RXPacketsLossRate=0
  else
    RXPacketsLossRate=$(( 100 * RXPacketsLoss / RXPacketsSum + (1000 * RXPacketsLoss / RXPacketsSum % 10 >= 5 ? 1 : 0) ))
  fi
    
  if [ $TXPacketsSum == 0 ]
  then
    TXPacketsLossRate=0
  else
    TXPacketsLossRate=$(( 100 * TXPacketsLoss / TXPacketsSum + (1000 * TXPacketsLoss / TXPacketsSum % 10 >= 5 ? 1 : 0) ))
  fi
  
  echo "CAN device $1 test report:"
  echo "  RX packets loss/sum: ${RXPacketsLoss}/${RXPacketsSum}=${RXPacketsLossRate}%"
  echo "  TX packets loss/sum: ${TXPacketsLoss}/${TXPacketsSum}=${TXPacketsLossRate}%"
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
    cansend $2 $3
  else
    cansend $2 1ff#0bb80bb80bb80bb8
    cansend $2 200#0bb80bb80bb80bb8
  fi
*)
  echo "Command not found, choices: [send, stat]"
  exit 1
esac
