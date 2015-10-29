class cobbler::install {

  package { $cobbler::package_name :
    ensure  => $cobbler::package_ensure,
  }
}
