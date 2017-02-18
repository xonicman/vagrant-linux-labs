#define /etc/hosts for all machines
class hostsfile {
    host { 'n17n1a.lab.itmz.pl': ip => '10.17.1.11', host_aliases => 'n17n1a', }
    host { 'n17n1b.lab.itmz.pl': ip => '10.17.1.22', host_aliases => 'n17n1b', }
    host { 'n17n2a.lab.itmz.pl': ip => '10.17.2.11', host_aliases => 'n17n2a', }
    host { 'n17n2b.lab.itmz.pl': ip => '10.17.2.22', host_aliases => 'n17n2b', }
    host { 'n17n1r.lab.itmz.pl': ip => '10.17.1.100', host_aliases => [ 'n17n1r', 'n17n1router' ], }
    host { 'n17n2r.lab.itmz.pl': ip => '10.17.2.200', host_aliases => [ 'n17n2r', 'n17n2router' ], }
    host { 'n17vs.lab.itmz.pl': ip => '10.17.21.100', host_aliases => [ 'n17vs', 'vpnserver', ], }
    host { 'n17vc.lab.itmz.pl': ip => '10.17.21.200', host_aliases => [ 'n17vc', 'vpnclient', ], }
}

class changeps1 {
 file_line {'set_PS1':
    path  => '/etc/bash.bashrc',
    line  => 'PS1="\[\e[1;34m\][\u@\h \w]\$\[\e[m\] "',
    match => '^\#?PS1=',
  }
}

class baseconfig {
  include hostsfile
  include changeps1
}

class route-to-n17-for-n1 {
  network::route { 'eth2':
    ipaddress => [ '10.17.0.0', ],
    netmask   => [ '255.255.0.0', ],
    gateway   => [ '10.17.1.100', ],
  }
}

class route-to-n17-for-n2 {
  network::route { 'eth3':
    ipaddress => [ '10.17.0.0', ],
    netmask   => [ '255.255.0.0', ],
    gateway   => [ '10.17.2.200', ],
  }
}

node 'n1a' {
  include baseconfig
  #include route-to-n17-for-n1
  network::interface { 'eth0': enable_dhcp => true, }
  network::interface { 'eth1': ipaddress => '192.168.21.11', netmask => '255.255.255.0', }
  network::interface { 'eth2': ipaddress => '10.17.1.11', netmask => '255.255.255.0', }
}

node 'n1b' {
  include baseconfig
  #include route-to-n17-for-n1
  network::interface { 'eth0': enable_dhcp => true, }
  network::interface { 'eth1': ipaddress => '192.168.21.12', netmask => '255.255.255.0', }
  network::interface { 'eth2': ipaddress => '10.17.1.22', netmask => '255.255.255.0', }
}

node 'n2a' {
  include baseconfig
  #include route-to-n17-for-n2
  network::interface { 'eth0': enable_dhcp => true, }
  network::interface { 'eth1': ipaddress => '192.168.21.21', netmask => '255.255.255.0', }
  network::interface { 'eth3': ipaddress => '10.17.2.11', netmask => '255.255.255.0', }
}

node 'n2b' {
  include baseconfig
  #include route-to-n17-for-n2
  network::interface { 'eth0': enable_dhcp => true, }
  network::interface { 'eth1': ipaddress => '192.168.21.22', netmask => '255.255.255.0', }
  network::interface { 'eth3': ipaddress => '10.17.2.22', netmask => '255.255.255.0', }
}

node 'vs' {
  include baseconfig
  network::interface { 'eth0': enable_dhcp => true, }
  network::interface { 'eth1': ipaddress => '192.168.21.100', netmask => '255.255.255.0', }
  network::interface { 'eth2': ipaddress => '10.17.1.100', netmask => '255.255.255.0', }
  network::interface { 'eth4': ipaddress => '10.17.21.100', netmask => '255.255.255.0', }
}

node 'vc' {
  include baseconfig
  network::interface { 'eth0': enable_dhcp => true, }
  network::interface { 'eth1': ipaddress => '192.168.21.200', netmask => '255.255.255.0', }
  network::interface { 'eth3': ipaddress => '10.17.2.200', netmask => '255.255.255.0', }
  network::interface { 'eth4': ipaddress => '10.17.21.200', netmask => '255.255.255.0', }
}


node 'default' {

}

if versioncmp($::puppetversion,'3.6.1') >= 0 {
  # Based on
  # https://ask.puppet.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

