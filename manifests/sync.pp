# Class: cobbler::sync
#
#  Einige Operationen im Cobbler benötigen einen "cobbler sync" Aufruf, um
#  Wirkung zu zeigen. Diese Klasse macht genau das.
#
class cobbler::sync () {

# cobbler sync command
  exec { 'cobblersync':
    command     => '/usr/bin/cobbler sync',
    refreshonly => true,
  }


}
