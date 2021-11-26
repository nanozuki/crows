function sync_wezterm
    title "sync wezterm"
    # if test $os = archlinux
    #     paru_install wezterm
    # else if test $os = macos
    #     # brew reinstall --cask wezterm-nightly --no-quarantine
    # end

    mkdir -p $config/wezterm
    ln -sf $dots/wezterm/wezterm.lua $config/wezterm/wezterm.lua
end
