const homeDir = Deno.env.get('HOME');
export default {
  xdg: {
    config: `${homeDir}/.config`,
    cache: `${homeDir}/.cache`,
    data: `${homeDir}/.local/share`,
  },
};
