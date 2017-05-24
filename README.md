# btrfs filesystem usage monitoring plugin

reads the estimated free space using `btrfs fi usage`


```plain
# ./check_btrfs_usage.sh -h
btrfs filesystem usage monitoring plugin
https://github.com/psi-4ward/check_btrfs_usage

Usage: ./check_btrfs_usage.sh <options>
  -m <mount>    Mountpoint of btrfs filesystem (default: /)
  -w <warn>     Warning when estimated free space is below MiB (default 10000)
  -c <crit>     Critical when estimated free space is below MiB (default 5000)
```

```plain
# ./check_btrfs_usage.sh -m /mnt/btrfs_root -w 20000 -c 10000
Free: 2848841MiB
Used: 7239MiB
 | Used=7239MB;0;0;0;2856080 Free=2848841MB;20000;10000;2856080;0 
```

Author: Christoph Wiechert  
License: MIT  