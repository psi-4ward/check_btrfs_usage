#!/bin/bash
# btrfs filesystem usage monitoring plugin
#
# reads the estimated free space using `btrfs fi usage`
#
# https://github.com/psi-4ward/check_btrfs_usage
# Author: Christoph Wiechert
# License: MIT

set -e

WARN=10000
CRIT=5000
MOUNT="/"
USE_PERC=0

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
while [[ $# -ge 1 ]] ; do
  arg="$1"
  case $arg in
    -m)
      MOUNT="$2"
      shift
    ;;
    -w)
      WARN="$2"
      shift
    ;;
    -c)
      CRIT="$2"
      shift
    ;;
    -h|--help)
      echo "btrfs filesystem usage monitoring plugin"
      echo "https://github.com/psi-4ward/check_btrfs_usage"
      echo
      echo "Usage: $0 <options>"
      echo "  -m <mount>    Mountpoint of btrfs filesystem (default: /)"
      echo "  -w <warn>     Warning when estimated free space is below MiB (default 10000). Add % at the end to define in percentage value. Must be used the same way as crit value."
      echo "  -c <crit>     Critical when estimated free space is below MiB (default 5000). Add % at the end to define in percentage value. Must be used the same way as warn value."
      exit 0
    ;;
  esac
  shift
done

export LC_ALL=C
FREE_MB=$(btrfs fi usage $MOUNT -m | grep -F "estimated" | awk '{match($0,"min: ([0-9]+)",a)}END{print a[1]}')
USED_MB=$(btrfs fi usage $MOUNT -m | grep -F "    Used" | awk '{match($0,"([0-9]+)",a)}END{print a[1]}')
SUM_MB=$(($USED_MB + $FREE_MB))
EXIT_STATE=${STATE_OK}

if [[ $WARN =~ .*%$ && $CRIT =~ .*%$ ]] ; then
  WARN=${WARN%?}
  CRIT=${CRIT%?}
  WARN_MB=$(($SUM_MB*$WARN/100))
  CRIT_MB=$(($SUM_MB*$CRIT/100))
  USE_PERC=1
fi

if [[ $FREE_MB -lt $CRIT_MB && $USE_PERC -eq 1 ]] ; then
  EXIT_STATE=${STATE_CRITICAL}
  echo -n "CRITICAL "
elif [[ $FREE_MB -lt $WARN_MB && $USE_PERC -eq 1 ]] ; then
  echo -n "WARNING "
  EXIT_STATE=${STATE_WARNING}
elif [[ $FREE_MB -lt $CRIT && $USE_PERC -eq 0 ]] ; then
  EXIT_STATE=${STATE_CRITICAL}
  echo -n "CRITICAL "
elif [[ $FREE_MB -lt $WARN && $USE_PERC -eq 0 ]] ; then
  echo -n "WARNING "
  EXIT_STATE=${STATE_WARNING}
fi

if [ $USE_PERC -eq 1 ] ; then
  echo "Free: ${FREE_MB}MB"
  echo "Warning threshold: ${WARN_MB}MB "
  echo "Critical threshold: ${CRIT_MB}MB"
  echo "Used: ${USED_MB}MB"
  echo " | Used=${USED_MB}MB;0;0;0;${SUM_MB}   Free=${FREE_MB}MB;${WARN};${CRIT};${SUM_MB};0"
elif [ $USE_PERC -eq 0 ] ; then
  echo "Free: ${FREE_MB}MiB"
  echo "Warning threshold: ${WARN}MB "
  echo "Critical threshold: ${CRIT}MB"
  echo "Used: ${USED_MB}MB"
  echo " | Used=${USED_MB}MB;0;0;0;${SUM_MB} Free=${FREE_MB}MB;${WARN};${CRIT};${SUM_MB};0"
fi

exit ${EXIT_STATE}