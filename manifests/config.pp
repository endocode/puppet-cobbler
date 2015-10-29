class cobbler::config {

  File {
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  file { '/etc/init.d/cobblerd':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/cobbler/cobbler.d',
  } ->
  file { "${cobbler::apache_path}conf.d/proxy_cobbler.conf":
    content => template('cobbler/proxy_cobbler.conf.erb'),
  } ->

  file { $cobbler::distro_path :
    ensure => directory,
    mode   => '0755',
  } ->
  file { "${cobbler::distro_path}/kickstarts" :
    ensure => directory,
    mode   => '0755',
  } ->
  file { '/etc/cobbler/settings':
    content => template('cobbler/settings.erb'),
    require => Package[$cobbler::package_name],
    notify  => Service[$cobbler::service_name],
  } ->
  file { '/etc/cobbler/modules.conf':
    content => template('cobbler/modules.conf.erb'),
    require => Package[$cobbler::package_name],
    notify  => Service[$cobbler::service_name],
  } ->
  file { "${cobbler::apache_path}conf.d/distros.conf": content => template('cobbler/distros.conf.erb'), } ->
  file { "${cobbler::apache_path}conf.d/cobbler.conf": content => template('cobbler/cobbler.conf.erb'), } 

  # purge resources
  if $cobbler::purge_distro == true {
    resources { 'cobblerdistro':  purge => true, }
  }
  if $cobbler::purge_repo == true {
    resources { 'cobblerrepo':    purge => true, }
  }
  if $cobbler::purge_profile == true {
    resources { 'cobblerprofile': purge => true, }
  }
  if $cobbler::purge_system == true {
    resources { 'cobblersystem':  purge => true, }
  }

}
