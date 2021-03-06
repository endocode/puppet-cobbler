# Class: cobbler::params
#
#   The cobbler default configuration settings.
#
class cobbler::params {
  case $::osfamily {
    'RedHat': {
      $service_name = 'cobblerd'
      $package_name = ['cobbler', 'tftp-server', 'syslinux']
      $use_epel = true
      $apache_path = '/etc/httpd/'
    }
    'Debian': {
      $service_name = 'cobblerd'
      $package_name = 'cobbler'
      $use_epel     = false
      $apache_path  = '/etc/apache2/'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat & Debian")
    }
  }
  $package_ensure = 'present'

  # general settings
  $next_server_ip = $::ipaddress
  $server_ip      = $::ipaddress
  $distro_path    = '/distro'
  $nameservers    = ['127.0.0.1']

  # default root password for kickstart files
  $defaultrootpw = 'bettergenerateityourself'

  # dhcp options
  $manage_dhcp        = false
  $dhcp_option        = 'isc'
  $dhcp_interfaces    = ['eth0']
  $dhcp_dynamic_range = false
  $dhcp_range_start   = 100
  $dhcp_range_end     = 200
  $dhcp_lease_default = 21600
  $dhcp_lease_max     = 43200

  # dns options
  $manage_dns = false
  $dns_option = 'dnsmasq'

  # tftpd options
  $manage_tftpd = true
  $tftpd_option = 'in_tftpd'

  # puppet integration setup
  $puppet_auto_setup                     = 1
  $sign_puppet_certs_automatically       = 1
  $remove_old_puppet_certs_automatically = 1

  # depends on apache
  $apache_service = 'httpd'
  # access, regulated through Proxy directive
  $allow_access = "${server_ip} ${::ipaddress} 127.0.0.1"

  # purge resources that are not defined
  $purge_distro  = false
  $purge_repo    = false
  $purge_profile = false
  $purge_system  = false
}
