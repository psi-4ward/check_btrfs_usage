# btrfs filesystem usage monitoring plugin

reads the estimated free space using `btrfs fi usage`


```plain
# ./check_btrfs_usage.sh -h
btrfs filesystem usage monitoring plugin
https://github.com/psi-4ward/check_btrfs_usage

Usage: ./check_btrfs_usage.sh <options>
  -m <mount>    Mountpoint of btrfs filesystem (default: /)
  -w <warn>     Warning when estimated free space is below MiB (default 10000). Add % at the end to define in percentage value. Must be used the same way as crit value.
  -c <crit>     Critical when estimated free space is below MiB (default 5000). Add % at the end to define in percentage value. Must be used the same way as warn value.
```

```plain
# ./check_btrfs_usage.sh -m /mnt/btrfs_root -w 20000 -c 10000
Free: 2848841MiB
Used: 7239MiB
 | Used=7239MB;0;0;0;2856080 Free=2848841MB;20000;10000;2856080;0

# ./check_btrfs_usage.sh -m / -c 5% -w 10%
Free: 367419MB
Warning threshold: 38436MB
Critical threshold: 19218MB
Used: 16941MB
 | Used=16941MB;0;0;0;384360   Free=367419MB;10;5;384360;0
```

Author: Christoph Wiechert  
License: MIT  