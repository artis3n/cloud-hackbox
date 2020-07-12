#! /bin/sh

test x"$SHELL" = x"" && SHELL=/bin/bash
test x"$1"     = x"" && set -- default

vncconfig -iconic &
"$SHELL" -l <<EOF
exec /etc/X11/Xsession "$@"
EOF
vncserver -kill "$DISPLAY"
