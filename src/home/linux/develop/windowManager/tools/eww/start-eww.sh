#! /usr/bin/env nix-shell
#! nix-shell -p bash eww -i bash

eww daemon
sleep 1
eww open bar
