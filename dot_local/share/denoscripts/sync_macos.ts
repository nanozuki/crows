import fish from './fish.ts';

// 1. set system environment

fish.setUx('XDG_CONFIG_HOME', '$HOME/.config');
fish.setUx('XDG_CACHE_HOME', '$HOME/.cache');
fish.setUx('XDG_DATA_HOME', '$HOME/.local/share');
fish.setUx('LC_ALL', 'en_US.UTF-8');
fish.setUx('LANG', 'en_US.UTF-8');
fish.setUx('EDITOR', 'nvim');
fish.setUx('XDG_RUNTIME_DIR', '$TMPDIR');
fish.setUx(
  'fish_user_paths',
  '~/.local/bin',
  '/opt/homebrew/bin',
  '/usr/local/bin',
  '/usr/local/sbin',
  '/usr/bin',
  '/usr/sbin',
  '/bin',
  '/sbin',
  '/Library/Apple/usr/bin'
);

// 2.
