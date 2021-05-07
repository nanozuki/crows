function detect_os
    if set -q os
        return
    end
    switch (uname)
        case Darwin
            set -U os macos
        case Linux
            if string match 'Arch*' (cat /etc/issue)
                set -U os archlinux
            end
    end
    if not set -q os
        set -U os unknown
        return 1
    end
end
