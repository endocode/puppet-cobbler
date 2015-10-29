class cobbler::prerequisites {

  case $::osfamily {
    'RedHat': {
      if $cobbler::use_epel == true {
        package { 'epel-release': ensure  => present, }
      } else {
        notify {'Don\'t using EPEL. Be sure that all needed packages available elsewhere.': }
      }
    }
    'Debian': {

      include apt

      apt::key { 'cobbler':
        id     => '2589A1ED',
        source => 'http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Debian_7.0/Release.key',
      }

      apt::source { 'cobbler':
      location    => 'http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Debian_7.0/',
      release     => './',
      repos       => ' ',
      include_src => false,
      require     => Apt::Key['cobbler'],
      }

    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat")
    }
  }

}
