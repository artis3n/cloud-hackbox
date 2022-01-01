#! /bin/sh

test "$SHELL" = "" && SHELL=/bin/bash
test "$1"     = "" && set -- default

vncconfig -iconic &
"$SHELL" -l <<EOF
exec /etc/X11/Xsession "$@"
EOF
vncserver -kill "$DISPLAY"
