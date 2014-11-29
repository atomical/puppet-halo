define halo::server(
  $path        = undef,
  $owner       = undef,
  $group       = undef,

  # in game configuration
  $name              = undef,
  $port              = 2302,
  $max_players       = 16,
  $motd              = "",
  $time_limit        = 30,
  $map_cycle_timeout = 3,
  $rcon_password     = undef,

  $formatted_name = inline_template("<%= @name.split(' ').join('_') %>"),

){

  include halo::wine
  include upstart

  file { "${path}":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
  }

  file { "${path}/sapp":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
  }

  file{ "${path}/maps":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
  }

  file { "${path}/haloded.exe":
    ensure => present,
    source => "puppet:///modules/halo/haloded.exe",
    owner  => $owner,
    group  => $group,
  }
  
  file { "${path}/sapp.dll":
    ensure => present,
    source => "puppet:///modules/halo/sapp.dll",
    owner  => $owner,
    group  => $group,
  }
  
  file { "${path}/strings.dll":
    ensure => present,
    source => "puppet:///modules/halo/strings.dll",
    owner  => $owner,
    group  => $group,
  }
  
  file { "${path}/init.txt":
    path    => "${path}/init.txt",
    owner   => $owner,
    group   => $group,
    content => template('halo/init.erb'),
    require => File["${path}"],
  }

  file { "${path}/sapp/init.txt":
    path    => "${path}/sapp/init.txt",
    owner   => $owner,
    group   => $group,
    content => template('halo/sapp/init.erb'),
    require => File["${path}/sapp"],
  }

  file { "${path}/maps/bloodgulch.map":
    ensure => present,
    source => 'puppet:///modules/halo/bloodgulch.map',
    owner  => $owner,
    group  => $group,
    require => File["${path}/maps"],
  }

  file { "${path}/maps/ui.map":
    ensure => present,
    source => 'puppet:///modules/halo/ui.map',
    owner  => $owner,
    group  => $group,
    require => File["${path}/maps"],
  }


  upstart::job { $formatted_name:
    description    => 'halo server',
    version        => "3626f2",
    respawn        => true,
    respawn_limit  => '5 10',
    user           => $user,
    group          => $group,
    chdir          => $path,
    exec           => "/usr/bin/wine haloded.exe -path ${path} -port ${port}",
  }
  # first map
  # archive { 'bigassv3_1.zip':
  #   ensure => present,
  #   url    => 'http://halomd.macgamingmods.com/mods/bigassv3_1.zip',
  #   target => "${path}/maps",
  #   follow_redirects => true,
  #   checksum => true,
  #   src_target => '/tmp',
  # }

  # archive { 'imposing_1.zip':
  #   ensure => present,
  #   url    => 'http://halomd.macgamingmods.com/mods/imposing_1.zip',
  #   target => "${path}/maps",
  #   follow_redirects => true,
  #   checksum => true,
  #   src_target => '/tmp',
  # }


}