class cobbler::prerequisites {

  if $::osfamily == 'RedHat' {
    if $cobbler::use_epel == true {
      package { 'epel-release': ensure  => present, }
    } else {
      notify {'Don\'t using EPEL. Be sure that all needed packages available elsewhere.': }
    }
  }

}
