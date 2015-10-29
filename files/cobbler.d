#!/bin/sh
#
# cobblerd    Cobbler helper daemon
###################################

# LSB header

### BEGIN INIT INFO
# Provides: cobblerd
# Required-Start: $network $xinetd $httpd
# Required-Stop: $network $xinetd $httpd
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: daemon for libvirt virtualization API
# Description: This is a daemon that a provides remote cobbler API
#              and status tracking
### END INIT INFO

# chkconfig header

# chkconfig: 345 99 99 
# description:  This is a daemon that provides a remote cobbler API
#               and status tracking
#
# processname: /usr/bin/cobblerd

# Sanity checks.
[ -x /usr/bin/cobblerd ] || ( 
    echo "Error, could not find executable: /usr/bin/cobblerd"
    exit 1
)

DEBIAN_VERSION=/etc/debian_version
SUSE_RELEASE=/etc/SuSE-release
# Source function library.
if [ -f $DEBIAN_VERSION ]; then
    . /lib/lsb/init-functions
elif [ -f $SUSE_RELEASE -a -r /etc/rc.status ]; then
    . /etc/rc.status
else
    . /etc/rc.d/init.d/functions
fi

if [ -f /etc/default/cobblerd ]; then
    . /etc/default/cobblerd
fi
if [ "x${CONFIG_ARGS}" = "x" ]; then
    CONFIG_ARGS=" "
fi

SERVICE=cobblerd
PROCESS=cobblerd

if [ -f $DEBIAN_VERSION -o -f $SUSE_RELEASE ]; then
    LOCKFILE=/var/lock/$SERVICE
else
    LOCKFILE=/var/lock/subsys/$SERVICE
fi
WSGI=/usr/share/cobbler/web/cobbler.wsgi

RETVAL=0

start() {
    echo -n "Starting cobbler daemon: "
    if [ -f $SUSE_RELEASE ]; then
        startproc -p /var/run/$SERVICE.pid /usr/bin/cobblerd $CONFIG_ARGS
        rc_status -v
    elif [ -e $DEBIAN_VERSION ]; then
        pgrep -f "/usr/bin/python /usr/bin/cobblerd" > /dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            echo -n "already started" 
            RETVAL=1
        elif /usr/bin/python /usr/bin/cobblerd; then
            echo -n "OK"
            RETVAL=0
        fi
    else
        daemon --check $SERVICE $PROCESS --daemonize $CONFIG_ARGS
    fi
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch $LOCKFILE
    [ -f $WSGI ] && touch $WSGI
    return $RETVAL
}

stop() {
    echo -n "Stopping cobbler daemon: "
    if [ -f $SUSE_RELEASE ]; then
        killproc -TERM /usr/bin/cobblerd
        rc_status -v
    elif [ -f $DEBIAN_VERSION ]; then
        # Added this since Debian's start-stop-daemon doesn't support spawned processes, will remove
        # when cobblerd supports stopping or PID files.
        if pkill -f "/usr/bin/python /usr/bin/cobblerd" > /dev/null 2>&1 ; then
            echo -n "OK"
            RETVAL=0
        else
            echo -n "Daemon is not started"
            RETVAL=1
        fi
    else
        killproc $PROCESS
    fi
    RETVAL=$?
    echo
    if [ $RETVAL -eq 0 ]; then
    rm -f $LOCKFILE
        rm -f /var/run/$SERVICE.pid
    fi
}
restart() {
   stop
   start
}

# See how we were called.
case "$1" in
    start|stop|restart)
        $1
        ;;
    status)
        if [ -f $SUSE_RELEASE ]; then
            echo -n "Checking for service cobblerd "
            checkproc /usr/bin/cobblerd
            rc_status -v
        elif [ -f $DEBIAN_VERSION ]; then
            pgrep -f "/usr/bin/python /usr/bin/cobblerd" > /dev/null 2>&1
            if [ "$?" -eq 0 ]; then
                RETVAL=0
                echo "cobblerd is running."
            else
                RETVAL=1
                echo "cobblerd is stopped."
            fi
        else
            status $PROCESS
            RETVAL=$?
        fi
        ;;
    condrestart)
        [ -f $LOCKFILE ] && restart || :
        ;;
    reload)
        echo "can't reload configuration, you have to restart it"
        RETVAL=$?
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart|condrestart|reload}"
        exit 1
        ;;
esac
exit $RETVAL