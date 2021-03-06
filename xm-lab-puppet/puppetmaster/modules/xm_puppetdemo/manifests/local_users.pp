#Add local users
class xm_puppetdemo::local_users {
  user { 'leon':
    ensure     => 'present',
    comment    => 'Leon Zalewski',
    uid        => '5002',
    shell      => '/bin/bash',
    managehome => true,
  }

  ssh_authorized_key { 'leon_public_key':
    user    => 'leon',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAqPUbyclrc3qMT7xeNLLN2+unClpFqEdgiwA4AYP7bjWTkvHL2H2vXA2EiWKBvD69nOrRQ8Gn0RS9ylZt7R5qo6l+r/24JJ56mQajxk8hGleM/nXVQL6gKGLonp1kTwSlfTZuaAlC+gCKtGn3B3M/kXxwS0NReZdxhV/aGLb4Mrx2O5Xc56YwH4jAAq7u5K9VC4VUAS59YPDEZT/WFSGJgiahzJiWa/8VR5N6P/vLe2mvOQLNUZQ6GjXWpqW08aP3U5eIHvbeex6WSHQrheMqE5WQ9XufD7MPGwRGi6Tdgj1oWAWMSDQ1eel+7LD7d6OEM/JXnWJFHun8qGNby3sJWw==',
    require => User['leon'],
  }
}
