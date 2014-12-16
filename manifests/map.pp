define halo::map (
  $path = '/var/halo_maps',
  $extension = undef,
  $url  = undef,
){

   archive { $title:
    ensure => present,
    timeout => 20000,
    url    => $url,
    extension => $extension,
    target => $path,
    follow_redirects => true,
    checksum => true,
    src_target => '/tmp',
  }
}

# example
# halo::map{ 'bigassv3_1':
#   url => 'http://halomd.macgamingmods.com/mods/bigassv3_1.zip',
#   extension => 'zip',
# }