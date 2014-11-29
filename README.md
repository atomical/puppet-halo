### Halo Server 

This puppet module sets up a halo server with [SAPP](xhalo.tk) for the popular [HaloMD](http://halomd.net) client.  The guide for the vanilla dedicated server is [here](http://forums.gearboxsoftware.com/showthread.php?t=65330).  Don't forget to set `rcon_password` in ``halo::server``.


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
}

```