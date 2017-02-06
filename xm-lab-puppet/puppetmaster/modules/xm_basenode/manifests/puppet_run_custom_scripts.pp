#Scripts for easier work with puppet agent
class xm_basenode::puppet_run_custom_scripts {
  file { '/usr/local/sbin/puppet.run.once.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => "#!/bin/sh\n#puppetfile\npuppet agent --no-daemonize --onetime --verbose ${1}\n",
  }

  # noop - no-operation - just look what puppet would change
  file { '/usr/local/sbin/puppet.run.noop.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => file ('xm_basenode/puppet_run_noop.sh'),
    #source => 'puppet:///files/usr/local/sbin/puppet_run_noop.sh', #also possible way
  }


}
