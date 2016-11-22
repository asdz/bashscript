#!/bin/bash

smartctl -a /dev/sda > /root/smartStates

grep Reallocated_Sector_Ct /root/smartStates > /root/stats
grep Current_Pending_Sector /root/smartStates >> /root/stats
grep Offline_Uncorrectable /root/smartStates >> /root/stats
grep UDMA_CRC_Error_Count /root/smartStates >> /root/stats
    
touch /root/statsOld
cmp /root/stats /root/statsOld
result=$?
    
if [[ $result -ne "1" && $result -ne "0" ]]
  then
    echo "Something went wrong"
    exit -1
fi

if [[ $result -eq "1" ]]
  then
    echo "Files are different\n"
    cat /root/stats
fi
    
mv /root/stats /root/statsOld
rm /root/smartStates
