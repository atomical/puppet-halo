define halo::server(
  $path        = undef,
  $map_path    = '/var/halo_maps',
  $owner       = undef,
  $group       = undef,
  $dns_servers = ['halo.macgamingmods.com'],  # or s1.ms01.hosthpc.com or s1.master.hosthpc.com

  # in game configuration
  $name              = undef,
  $port              = undef,
  $maps              = [],
  $game_type         = undef,

  # sapp specific
  $max_players       = 16,
  $motd              = "",
  $time_limit        = 30,
  $map_cycle_timeout = 3,
  $rcon_password     = undef,
  $no_lead           = 1,
  $ping_kick         = 0,
  $antihalofp        = 0,
  $log               = 1,
  $lua               = 1,
  $spawn_protection  = 0,
  $collect_aliases   = 1,
  $afk_kick          = 600,
  $anti_warp         = 0,
  $lua               = 0,
  $anti_caps         = 1,
  $anti_spam         = 1,
  $save_scores       = 1,

  $formatted_name = inline_template("<%= @name.split(' ').join('_') %>"),

){

  include halo::wine
  include upstart

  file { $path:
    source => "puppet:///modules/halo/server",
    owner   => $owner,
    group   => $group,
    recurse => true,
  }

  file{ "${path}/maps":
    ensure  => link,
    target  => $map_path,
    owner   => $owner,
    group   => $group,
    require => File[$map_path],
  }

  file { "${path}/init.txt":
    path    => "${path}/init.txt",
    owner   => $owner,
    group   => $group,
    content => template('halo/init.erb'),
  }

  file { "${path}/sapp/init.txt":
    path    => "${path}/sapp/init.txt",
    owner   => $owner,
    group   => $group,
    content => template('halo/sapp/init.erb'),
  }

  file { "${path}/motd.txt":
    path    => "${path}/motd.txt",
    owner   => $owner,
    group   => $group,
    content => template('halo/motd.erb'),
  }

  File[$path] -> File[$map_path] -> File["${path}/maps"] -> File["${path}/init.txt"] -> 
  File["${path}/sapp/init.txt"] -> File["${path}/motd.txt"] -> Upstart::Job[$title]

  upstart::job { $title:
    description    => 'halo server',
    version        => "3626f2",
    respawn        => true,
    respawn_limit  => '5 10',
    user           => $owner,
    group          => $group,
    chdir          => $path,
    exec           => "/usr/bin/wine haloded.exe -path ${path} -port ${port}",
    require        => Class['halo::wine'],
    kill_signal    => 'SIGKILL',
    # restart        => [File["${path}/sapp/init.txt"]],
    subscribe      => [File["${path}/sapp/init.txt"], File["${path}/init.txt"],],
  }

}
