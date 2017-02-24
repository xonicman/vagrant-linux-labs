```
+----------------------------------------------------------------------------------------------------+
|                                                                                                    |
|                                   Vagrant / VirtualBox Hypervisor                                  |
| vbox NAT network 10.0.x.0/24                                                                       |
+-------+---------------------------------+--------------------------------+-----------+---------+---+
        |                                 |                                |           |         |
        |                                 |                                |           |         |
        |                                 |                                +           |         |
        |                                 |                               eth0         |         |
        |                                 |                            +-----------+   |         |
        |                                 |                            | lanserver |   |         |
        +                                 +                            |           |   |         |
       eth0                              eth0                  +--+eth1|  IP:31    |   |         |
+----------------+                   +----------+              |       |           |   |         |
|    internet    |                   | firewall |              |       +-----------+   |         |
|                |   10.ZZZ.99.x/24  |          |              |                       |         |
|     IP:99      |eth3+--------+eth3 |  IP:111  |eth1+---------+-------+               +         |
|                |                   |          |      10.ZZZ.33.x/24  |              eth0       |
+----------------+                   +----------+                      |      +-----------+      |
                                         eth2                          |      | lanclient |      |
                                          +                            |      |           |      |
                                          |                            +-+eth1|  IP:32    |      |
                                          |10.ZZZ.66.x/24                     |           |      |
                                          |                                   +-----------+      |
                                          +                                                      |
                                         eth2                                                    |
                                     +-----------+                                               |
 github.com/                         | dmzserver |                                               |
   xonicman/vagrant-linux-labs       |           |                                               |
   /xm-lab-firewall                  |   IP:61   |eth0+------------------------------------------+
                                     |           |
 Created with asciiflow.com          |           |
                                     +-----------+
```

ZZZ=101 - master branch  
ZZZ=102 - set2 branch  
ZZZ=102 - set3 branch  
ZZZ=102 - set4 branch  