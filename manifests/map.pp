define halo::map (
  $name = undef,
  $path = undef,
  $url  = undef,
){

   archive { $name:
    ensure => present,
    url    => $url,
    target => "${path}/maps",
    follow_redirects => true,
    checksum => true,
    src_target => '/tmp',
  }
}