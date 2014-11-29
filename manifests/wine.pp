class halo::wine {
  # exec { "apt-get update":
  #     command => "/usr/bin/apt-get update"
  # }

  package { 'wine': 
    ensure => present,
    # require  => Exec['apt-get update'],
  }

  exec { 'winetricks sound=oss':
    command => "winetricks sound=oss",
    require => Package['wine'],
  }

}