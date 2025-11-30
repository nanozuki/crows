#!/bin/sh
export BEMENU_OPTS="--fn 'monospace 12' --prefix=» --prompt '  ' --tb=#f2e9de --tf=#575279 --fb=#f2e9de --ff=#575279 --cb=#f2e9de --cf=#575279 --nb=#f2e9de --nf=#575279 --ab=#f2e9de --af=#575279 --hb=#b4637a --hf=#eee9e6 --sb=#9893a5 --sf=#575279 --scb=#faf4ed --scf=#575279"
j4-dmenu-desktop --dmenu="bemenu -i -l 10" --term="wezterm" --usage-log="~/.cache/j4-dmenu-desktop/usage.log"
