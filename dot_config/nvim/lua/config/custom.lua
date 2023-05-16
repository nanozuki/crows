-- available themes:
--  rose_pine (variant: 'main', 'dawn', 'moon'),
--  edge (variant: 'dark', 'aura', 'neon', 'light'),
--  nord,

return {
  theme = {
    name = 'rose_pine',
    variant = 'dawn',
  },
  built_in_languages = { 'lua', 'viml', 'json', 'yaml', 'markdown' },
  use_copilot = true,
  opt_languages = {
    go = true,
    ocaml = true,
    rust = true,
    typescript = true,
    terraform = true,
    zig = true,
  },
}
