#define /etc/hosts for all machines
class hostsfile {
    host { 'n17n1a.lab.itmz.pl': ip => '10.17.1.11', host_aliases => 'n17n1a', }
    host { 'n17n1b.lab.itmz.pl': ip => '10.17.1.22', host_aliases => 'n17n1b', }
    host { 'n17n2a.lab.itmz.pl': ip => '10.17.2.11', host_aliases => 'n17n2a', }
    host { 'n17n2b.lab.itmz.pl': ip => '10.17.2.22', host_aliases => 'n17n2b', }
    host { 'n17n1r.lab.itmz.pl': ip => '10.17.1.100', host_aliases => [ 'n17n1r', 'n17n1router' ], }
    host { 'n17n2r.lab.itmz.pl': ip => '10.17.2.200', host_aliases => [ 'n17n2r', 'n17n2router' ], }
    host { 'n17v1.lab.itmz.pl': ip => '10.17.21.100', host_aliases => [ 'n17v1', 'vpnserver', ], }
    host { 'n17v2.lab.itmz.pl': ip => '10.17.21.200', host_aliases => [ 'n17v2', 'vpnclient', ], }
}

class baseconfig {
  include hostsfile
}

node 'n1a' {
  include baseconfig
  network::interface { 'eth2': ipaddress => '10.17.1.11', netmask => '255.255.255.0', }
}

node 'n1b' {
  include baseconfig
  network::interface { 'eth2': ipaddress => '10.17.1.22', netmask => '255.255.255.0', }
}

node 'n2a' {
  include baseconfig
  network::interface { 'eth3': ipaddress => '10.17.2.11', netmask => '255.255.255.0', }
}

node 'n2b' {
  include baseconfig
  network::interface { 'eth3': ipaddress => '10.17.2.22', netmask => '255.255.255.0', }
}

node 'va' {
  include baseconfig
  network::interface { 'eth2': ipaddress => '10.17.1.100', netmask => '255.255.255.0', }
  network::interface { 'eth4': ipaddress => '10.17.21.100', netmask => '255.255.255.0', }
}

node 'vb' {
  include baseconfig
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

