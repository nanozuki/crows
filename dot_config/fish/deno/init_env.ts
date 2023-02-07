import exec from './lib/exec.ts';
import fish from './lib/fish.ts';
import node from './lib/node.ts';
import { isMacOS } from './lib/os.ts';
import pkg from './lib/pkg.ts';
import plum from './lib/plum.ts';

async function initVars(): Promise<void> {
  await fish.setVar('XDG_CONFIG_HOME', '$HOME/.config');
  await fish.setVar('XDG_CACHE_HOME', '$HOME/.cache');
  await fish.setVar('XDG_DATA_HOME', '$HOME/.local/share');
  await fish.setVar('LC_ALL', 'en_US.UTF-8');
  await fish.setVar('LANG', 'en_US.UTF-8');
  await fish.setVar('EDITOR', 'nvim');
  if (isMacOS) {
    await fish.setVar('XDG_RUNTIME_DIR', '$TMPDIR');
    await fish.setPath([
      '~/.local/bin',
      '/opt/homebrew/bin',
      '/usr/local/bin',
      '/usr/local/sbin',
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin',
      '/Library/Apple/usr/bin',
    ]);
  } else {
    await fish.setPath([
      '~/.local/bin',
      '/usr/local/bin',
      '/usr/local/sbin',
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin',
    ]);
  }
}

// initFish to fit the config.fish
async function initFish(): Promise<void> {
  await fish.installFisher();
  await fish.installPlugins('jethrokuan/z', 'PatrickF1/fzf.fish');
  const tools = ['exa', 'starship', 'tmux', 'fzf'];
  if (isMacOS) {
    await pkg.brewInstall(...tools);
  } else {
    await pkg.paruInstall(...tools);
  }
}

// required by neovim
async function initNode(): Promise<void> {
  if (await fish.hasCommand('npm')) {
    return;
  }
  await node.installLTS();
}

async function initNeovim(): Promise<void> {
  if (await fish.hasCommand('nvim')) {
    return;
  }
  if (isMacOS) {
    await pkg.brewInstall('neovim', 'python', 'ripgrep');
    await exec.run('pip3', 'install', 'pynvim');
  } else {
    await pkg.paruInstall('neovim', 'python-pynvim', 'ripgrep');
  }
  await node.npmPkgInstall('neovim');
  await fish.addPath(['$XDG_DATA_HOME/nvim/mason/bin']);
}

async function initBasic(): Promise<void> {
  if (await fish.hasCommand('nvim')) {
    return;
  }
  await initVars();
  await initFish();
  await initNode();
  await initNeovim();
}

async function initGnupg(): Promise<void> {
  if (await fish.hasCommand('gpg')) {
    return;
  }

  await fish.setVar('GNUPGHOME', '$XDG_DATA_HOME/gnupg');
  await exec.run('mkdir', '-p', '$GNUPGHOME');
  if (isMacOS) {
    await pkg.brewInstall('gnupg', 'pinentry-mac');
  } else {
    await pkg.paruInstall('gnupg', 'pinentry');
  }
}

async function initRime(): Promise<void> {
  if (await plum.isIstalled()) {
    return;
  }
  if (isMacOS) {
    pkg.brewInstall({ name: 'squirrel', cask: true });
  } else {
    pkg.paruInstall('fcitx5-rime');
  }
  await plum.install();
}

async function initGolang(): Promise<void> {
  if (await fish.hasCommand('go')) {
    return;
  }
  await fish.setVar('GOPATH', '$XDG_DATA_HOME/go');
  await fish.addPath(['$GOPATH/bin']);
  if (isMacOS) {
    await pkg.brewInstall('go');
  } else {
    await pkg.paruInstall('go');
  }
}

async function initRust(): Promise<void> {
  if (await fish.hasCommand('cargo')) {
    return;
  }
  await fish.setVar('CARGO_HOME', '$XDG_DATA_HOME/cargo');
  await fish.setVar('RUSTUP_HOME', '$XDG_DATA_HOME/rustup');
  await fish.addPath(['$CARGO_HOME/bin']);
  if (isMacOS) {
    await pkg.brewInstall('rustup');
    await exec.run('rustup-init');
  } else {
    await exec.run('sudo', 'pacman', '-S', '--needed', '--noconfirm', 'rustup');
    await exec.run('rustup', 'toolchain', 'install', 'stable');
    await exec.run('rustup', 'default', 'stable');
  }
}

async function initOCaml(): Promise<void> {
  if (await fish.hasCommand('opam')) {
    return;
  }
  await fish.setVar('OPAMROOT', '$XDG_DATA_HOME/opam');
  if (isMacOS) {
    await pkg.brewInstall('opam');
  } else {
    await pkg.paruInstall('opam');
  }
  await exec.run('opam', 'init', '--disable-shell-hook');
}

const allItems = new Map<string, () => Promise<void>>();
allItems.set('gpg', initGnupg);
allItems.set('rime', initRime);
allItems.set('go', initGolang);
allItems.set('rust', initRust);
allItems.set('ocaml', initOCaml);

async function init(): Promise<void> {
  if (Deno.args.length === 0) {
    const items = Array.from(allItems.keys());
    console.log('Please specify the init item(s)');
    console.log(`All items are: ${items}`);
  }
  await initBasic();
  for (const item of Deno.args) {
    const initFn = allItems.get(item);
    if (initFn) {
      console.log(`Init ${item}`);
      await initFn();
    } else {
      console.log(`Unknown Item ${item}, Skip.`);
    }
  }
}

await init();
