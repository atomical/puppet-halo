class halo::wine {
  class { 'apt':
    always_apt_update    => true,
    apt_update_frequency => undef,
    disable_keys         => undef,
    proxy_host           => false,
    proxy_port           => '8080',
    purge_sources_list   => false,
    purge_sources_list_d => false,
    purge_preferences_d  => false,
    update_timeout       => undef,
    fancy_progress       => undef
  }

  # exec {"wine_update":
  #   command => "apt-get update -y",
  #   user => root,
  # }

  package { "wine":
    ensure => latest,
    require => Class['apt'],
  }

  exec { 'winetricks sound=oss':
    command => "winetricks sound=oss",
    require => Package['wine'],
  }

}