# Careful! This manifest is for Vagrant use!

node  'default' {

  class { 'cobbler':
    manage_dhcp        => true,
    dhcp_dynamic_range => true,
    nameservers        => [ '123.123.123.4', '123.123.123.2'],
  }

  class { cobbler::web: }
}
