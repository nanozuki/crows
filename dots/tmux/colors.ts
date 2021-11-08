// deno run --allow-write colors.ts
import { render } from "https://deno.land/x/mustache@v0.3.0/mod.ts";

const template = `# theme: {{theme}}
#   accent = {{accent}}
#   accent_sec = {{accent_sec}}
#   bg = {{bg}}
#   bg_sec = {{bg_sec}}
#   fg = {{fg}}
#   fg_sec = {{fg_sec}}

set -g status-justify "left"
set -g status "on"
set -g status-style "none,bg={{bg}}"
set -g status-left "#[fg={{bg}},bg={{accent}}] #S #[fg={{accent}},bg={{bg}}]"
set -g status-right "#[fg={{bg_sec}},bg={{bg}}]#[fg={{fg}},bg={{bg_sec}}] %Y-%m-%d  %H:%M #[fg={{accent_sec}},bg={{bg_sec}}]#[fg={{bg}},bg={{accent_sec}}] #h "
setw -g window-status-format "#[fg={{fg}},bg={{bg}}]  #I  #W  "
setw -g window-status-current-format "#[fg={{bg}},bg={{bg_sec}}]#[fg={{fg}},bg={{bg_sec}}] #I  #W #[fg={{bg_sec}},bg={{bg}}]"
`;

interface ColorPalette {
  theme?: string;
  accent: string;
  "accent_sec": string;
  bg: string;
  "bg_sec": string;
  fg: string;
  "fg_sec": string;
}

const colors: Record<string, ColorPalette> = {
  "gruvbox_light": {
    accent: "#d65d0e", // orange
    accent_sec: "#7c6f64", // fg4
    bg: "#ebdbb2", // bg1
    bg_sec: "#d5c4a1", // bg2
    fg: "#504945", // fg2
    fg_sec: "#665c54", // fg3
  },
  "gruvbox_dark": {
    accent: "#d65d0e", // orange
    accent_sec: "#a89984", // fg4
    bg: "#3c3836", // bg1
    bg_sec: "#504945", // bg2
    fg: "#d5c4a1", // fg2
    fg_sec: "#bdae93", // fg3
  },
  "edge_light": {
    accent: "#bf75d6", // bg_purple
    accent_sec: "#8790a0", // grey
    bg: "#eef1f4", // bg1
    bg_sec: "#dde2e7", // bg4
    fg: "#33353f", // default:bg1
    fg_sec: "#4b505b", // fg
  },
  nord: {
    accent: "#88c0d0", // nord8
    accent_sec: "#81a1c1", // nord9
    bg: "#3b4252", // nord1
    bg_sec: "#4c566a", // nord3
    fg: "#e5e9f0", // nord4
    fg_sec: "#d8dee9", // nord4
  },
  "rose-pine-dawn": {
    accent: "#b4637a", // bg_purple
    accent_sec: "#d7827e", // grey
    bg: "#f2e9de", // bg1
    bg_sec: "#e4dfde", // bg4
    fg: "#575279", // default:bg1
    fg_sec: "#6e6a86", // fg
  },
};

for (const theme in colors) {
  const value = colors[theme];
  value["theme"] = theme;
  const content = render(template, value);
  const target = `./${theme}.conf`;
  await Deno.writeTextFile(target, content);
}
