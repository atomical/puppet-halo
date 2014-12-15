### Halo Server 

This puppet module sets up a Halo Combat Evolved dedicated server with [SAPP](xhalo.tk) for the popular [HaloMD](http://halomd.net) client.

### About

This installs wine, the halo dedicated server, and the SAPP add-on which has advanced features such as no-lead. By default this is turned on.

### What is installed?

* Puppet
* [Wine](https://www.winehq.org/about/)
* Halo Dedicated Server [guide](http://forums.gearboxsoftware.com/showthread.php?t=65330)
* SAPP [home](http://xhalo.tk/) and [guide](http://opencarnage.net/index.php?/topic/3806-comprehensive-sapp-documentation-rev-14-sapp-841/).


### Example 
```ruby  
group { 'sapphalo':
  ensure => present,
  system => true,
}

user { 'sapphalo':
  ensure => present,
  system => true,
  managehome => true,
  require => Group['sapphalo'],
}


halo::server{ 'server':
  owner => 'sapphalo',
  group => 'sapphalo',
  path => '/home/halo-server',
  name => 'Test Halo Server',
  # rcon_password => 'set_me_to_something_secret_with_numbers',
  $spawn_protection => '2', # seconds
}

```
