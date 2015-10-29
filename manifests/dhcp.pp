# Class: cobbler::dhcp
#
# This module manages ISC DHCP for Cobbler
# https://fedorahosted.org/cobbler/
#
class cobbler::dhcp {

  # include ISC DHCP only if we choose manage_dhcp
  if $cobbler::manage_dhcp {
    package { 'dhcp':
      ensure => present,
    } ->
    service { 'dhcpd':
      enable  => true,
      require => Package['dhcp'],
    }->
    file { '/etc/cobbler/dhcp.template':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('cobbler/dhcp.template.erb'),
      require => Package[$cobbler::package_name],
      notify  => Exec['cobblersync'],
    }
  }
}
