#!/bin/sh

# --------------------------------------------------------------------------------------------------
# The success of this script depends on something already having non-exclusive connection with
# Serial port of Arduino Nano in PLC-14500-Nano over '/dev/ttyUSB0'. Otherwise the attempt to copy
# the script to '/dev/ttyUSB0' will reset Arduino Nano.
# The easiest way to ensure this on Linux environment, is to run 'minicom -D /dev/ttyUSB0 -b 9600'
# or 'putty' in another window. Arduino IDE Serial Monitor will not do because it catptures 
# '/dev/ttyUSB0' exclusively.
# --------------------------------------------------------------------------------------------------

# ------------------------------
# define script variables
# ------------------------------

file=/dev/null
port=/dev/ttyUSB0

# ------------------------------
# parse command line
# ------------------------------

case $# in
    2)
        file=$1
        port=$2
        ;;
    1)
        file=$1
        ;;
    *)
        echo "$0 <file> [<port>]"
        echo "   default value for port is /dev/USB0"
        exit 1
        ;;
esac

echo "flashing '$file' to PLC-14500-Nano connected to '$port'"

# ------------------------------------
# perorm sanity checks before flushing
# ------------------------------------

# is requested program file present
if [ ! -f $file ] ; then
    echo "Error: can not read '$file'!"
    exit 2
fi

# is requesting program file size == 256 bytes
filesize=$(wc -c <"$file")
if [ $filesize -ne 256 ] ; then
    echo "Error: '$file' size is not 256 bytes long! It is not a valid programr.!"
    exit 3
fi

# is requested port character device
if [ ! -c $port ] ; then
    echo "Error: no character device is found on '$port'!"
    exit 4
fi

# ----------------------------------
# flush the program to PLC14500-Nano
# ----------------------------------

# make sure minicom or putty is running
mc_proc=$(ps -e | grep minicom | wc -l)
putty_proc=$(ps -e | grep putty | wc -l)
mc_proc_pid=0
if [ $mc_proc -eq 0 ] && [ $putty_proc -eq 0 ] ; then
    # if neither is running try starting minicom in the background
    minicom -D $port -b 9600 & > /dev/null 2>&1
    mc_proc_pid=$!
    mc_proc=$(ps -e | grep minicom | wc -l)
    if [ $mc_proc -eq 0 ] ; then
        echo "Error: minocom is not running, Arduino Nano is not in the state to receive the script!\nPlease run 'minicom -D /dev/ttyUSB0 -b 9600' in another window."
        exit 5
    fi
    # give Arduino Nano some time to boot
    sleep 5
fi

# copy file to USB
cat $file > $port
if [ $? -ne 0 ] ; then
    echo "Error: writing program '$file' to '$port'!"
    # if we have started minicom process in the background kill it
    if [ $mc_proc_pid -ne 0 ] ; then
        kill $mc_proc_pid > /dev/null 2>&1
    fi
    exit 6
fi
# if we have started minicom process in the background kill it
if [ $mc_proc_pid -ne 0 ] ; then
    kill $mc_proc_pid > /dev/null 2>&1
fi
echo done.


#-------------------------------------------------------------
#rem original windows flash14500.cmd provided as reference
#-------------------------------------------------------------
#@echo off
#set file=%1%
#set port=%2%
#
#echo flashing %file% to PLC14500 on %port%
#mode %port% dtr=off rts=off baud=9600 parity=n data=8 stop=1
#copy %file% %port% /B
#timeout /t 5
#echo done.
#-------------------------------------------------------------

