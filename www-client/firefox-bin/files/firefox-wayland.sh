#!/bin/sh

#
# Run Mozilla Firefox under Wayland
#
export MOZ_ENABLE_WAYLAND=1
exec /opt/firefox/firefox "$@"
