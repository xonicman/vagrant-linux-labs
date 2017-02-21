node default {

  host { 'node41.lab.itmz.pl': ip => '192.168.31.41', host_aliases => [ 'node41', 'n41', 'd1', ], }
  host { 'node42.lab.itmz.pl': ip => '192.168.31.42', host_aliases => [ 'node42', 'n42', 'd2', ], }
  host { 'node43.lab.itmz.pl': ip => '192.168.31.43', host_aliases => [ 'node43', 'n43', 'c1', ], }
  host { 'node44.lab.itmz.pl': ip => '192.168.31.44', host_aliases => [ 'node43', 'n44', 'c2', ], }

  service { "puppet":
	ensure => stopped,
	enable => false,
  }

  file { "lab.box":
    path	=> "/lab",
    ensure	=> directory,
  }

  include schemafile

  $exec_update_command = $::operatingsystem ? {
    CentOS => '/bin/echo yum does not need to update',
    Debian => '/usr/bin/apt-get update',
    defaut => '/usr/bin/apt-get update',
  }

  exec { 'refresh-repository':
    command  => $exec_update_command,
  }

  #packages to install:
  $vim_package = $::operatingsystem ? {
    CentOS => 'vim-enhanced',
    Debian => 'vim',
    defaut => 'vim',
  }

  package { 'htop': ensure => installed, require => Exec['refresh-repository'], }
  package { $vim_package: ensure => installed, require => Exec['refresh-repository'], }
  package { 'tree': ensure => installed, require => Exec['refresh-repository'], }
  package { 'screen': ensure => installed, require => Exec['refresh-repository'], }

}

class schemafile {
	file { "schema.txt":
		require	=> File["lab.box"],
		path	=> "/lab/schema.txt",
		ensure 	=> "present",
		content	=> [ 
"+-----------------------------------------------------------------+
| Vagrant / VirtualBox Hypervisor                                 |
|                                                                 |
+vbox NAT network 10.0.x.x                                        |
+------+------------+------------+--------------------------------+
       |            |            |
       +            |            |
      eth0          |            |              +-----------------+
   +--------+       |            |              |                 |
   |        |       |            |              |                 |
   | node41 |eth1+------------------------------+                 |
   |  Deb8  |       |            |              |                 |
   |        |       +            |              | vbox Private    |
   +--------+      eth0          |              | network #1      |
      eth2      +--------+       |              |                 |
       +        |        |       |              |                 |
       |        | node42 |eth1+-----------------+ eg.             |
       |        |  Deb8  |       |              | 192.168.31.x/24 |
       |        |        |       +              |                 |
       |        +--------+      eth0            |                 |
       |           eth2      +--------+         |                 |
       |            +        |        |         |                 |
       |            |        | node43 |eth1+----+                 |
       |            |        |  Cen7  |         |                 |
       |            |        |        |         |                 |
       |            |        +--------+         |                 |
       |            |           eth2            |                 |
       |            |            +     node44   |                 |
       |            |            |      Cen7    +-----------------+
       |            |            |
+------+------------+------------+--------------------------------+
|                                                                 |
| vbox Private network #2 (ex. 192.168.32.x/24)                   |
|                                                                 |
+-----------------------------------------------------------------+
",], }
     
}
