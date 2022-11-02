// deno run --allow-write colors.ts
import { render } from 'https://deno.land/x/mustache@v0.3.0/mod.ts';

const template = `# theme: {{theme}}
#   accent = {{accent}}
#   accent_sec = {{accent_sec}}
#   bg = {{bg}}
#   bg_sec = {{bg_sec}}
#   fg = {{fg}}
#   fg_sec = {{fg_sec}}

set -g @h_overlay "{{bg_sec}}"
set -g @inactive "{{fg_sec}}"
set -g @accent "red"
set -g status-justify "left"
set -g status "on"
set -g message-command-style "fg=black,bg=#{@accent}"
set -g message-style "fg=black,bg=#{@accent}"
set -g mode-style "fg=black,bg=#{@accent}"
set -g status-style "fg=white,bg=#{?#{client_prefix},#{@accent},black}"
set -g status-left-length 100
set -g status-left "#[fg=black,bg=white]   #h #[fg=white,bg=brightblack]#[fg=brightblack,bg=#{@inactive}]#[fg=black] #S #[fg=#{@inactive},bg=#{?#{client_prefix},#{@accent},black}]"

set -g status-right-length 100
set -g status-right "#[fg=#{@inactive},bg=#{?#{client_prefix},#{@accent},black}]#[fg=black,bg=#{@inactive}]#{?pane_in_mode, #{pane_mode} ,}#[fg=brightblack,bg=#{@inactive}]#[fg=black,bg=brightblack] ﲅ #{client_width}:#{client_height} "

set -g window-status-separator ""
setw -g window-status-format "#[fg=#{?#{client_prefix},#{@accent},black},bg=#{@h_overlay}]#[fg=white] #W #[fg=#{@h_overlay},bg=#{@inactive}]#[fg=black] #I #[fg=#{@inactive},bg=#{?#{client_prefix},#{@accent},black}]"
setw -g window-status-current-format "#[fg=#{?#{client_prefix},#{@accent},black},bg=brightblack]#[fg=black] #W #[fg=brightblack,bg=magenta]#[fg=black] #I #[fg=magenta,bg=#{?#{client_prefix},#{@accent},black}]"
`;

interface ColorPalette {
  theme?: string;
  accent: string;
  accent_sec: string;
  bg: string;
  bg_sec: string;
  fg: string;
  fg_sec: string;
}

const colors: Record<string, ColorPalette> = {
  gruvbox_light: {
    accent: '#d65d0e', // orange
    accent_sec: '#7c6f64', // fg4
    bg: '#ebdbb2', // bg1
    bg_sec: '#d5c4a1', // bg2
    fg: '#504945', // fg2
    fg_sec: '#665c54', // fg3
  },
  gruvbox_dark: {
    accent: '#d65d0e', // orange
    accent_sec: '#a89984', // fg4
    bg: '#3c3836', // bg1
    bg_sec: '#504945', // bg2
    fg: '#d5c4a1', // fg2
    fg_sec: '#bdae93', // fg3
  },
  edge_light: {
    accent: '#bf75d6', // bg_purple
    accent_sec: '#8790a0', // grey
    bg: '#eef1f4', // bg1
    bg_sec: '#dde2e7', // bg4
    fg: '#33353f', // default:bg1
    fg_sec: '#4b505b', // fg
  },
  nord: {
    accent: '#88c0d0', // nord8
    accent_sec: '#81a1c1', // nord9
    bg: '#3b4252', // nord1
    bg_sec: '#4c566a', // nord3
    fg: '#e5e9f0', // nord4
    fg_sec: '#d8dee9', // nord4
  },
  'rose-pine-dawn': {
    accent: '#b4637a', // bg_purple
    accent_sec: '#d7827e', // grey
    bg: '#f2e9de', // bg1
    bg_sec: '#e4dfde', // bg4
    fg: '#575279', // default:bg1
    fg_sec: '#6e6a86', // fg
  },
};

for (const theme in colors) {
  const value = colors[theme];
  value['theme'] = theme;
  const content = render(template, value);
  const target = `./${theme}.conf`;
  await Deno.writeTextFile(target, content);
}
