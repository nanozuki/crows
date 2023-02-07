import exec from './lib/exec.ts';
import fish from './lib/fish.ts';
import node from './lib/node.ts';
import { isMacOS } from './lib/os.ts';
import pkg from './lib/pkg.ts';
import plum from './lib/plum.ts';

async function upgradeSystem(): Promise<void> {
  if (isMacOS) {
    await pkg.brewUpgrade();
    await exec.run('pip3', 'install', '-U', 'pynvim');
  } else {
    await pkg.paruUpgrade();
    await pkg.flatpakUpgrade();
  }
}

async function upgradeFisher(): Promise<void> {
  if (await fish.hasCommand('fisher')) {
    await fish.upgradePlugins();
  }
}

async function upgradeNpm(): Promise<void> {
  if (!(await fish.hasCommand('npm'))) {
    return;
  }
  if (!(await node.checkVersion())) {
    return;
  }
  await node.npmPkgUpgrade();
}

async function upgradeRust(): Promise<void> {
  if (await fish.hasCommand('rustup')) {
    await exec.run('rustup', 'update');
  }
}

async function upgradeCargo(): Promise<void> {
  if (!(await fish.hasCommand('cargo'))) {
    return;
  }
  const listOutput = await exec.output('cargo', 'install', '--list');
  for (const line of listOutput.split('\n')) {
    if (line.includes(' v')) {
      const pkg = line.trim().split(' v')[0];
      console.log(`reinstall cargo package: ${pkg}`);
      await exec.run('cargo', 'install', pkg);
    }
  }
}

async function upgradeRimePlum(): Promise<void> {
  if (await plum.isIstalled()) {
    await plum.upgrade();
  }
}

async function upgradeGoInstall(): Promise<void> {
  if (!(await fish.hasCommand('go'))) {
    return;
  }
  if (!(await fish.hasCommand('go-global-update'))) {
    await exec.run('go', 'install', 'github.com/Gelio/go-global-update@latest');
  }
  try {
    await exec.run('go-global-update');
  } catch {
    return; // ignore unimportant error
  }
}

async function upgradeOpam(): Promise<void> {
  if (!(await fish.hasCommand('opam'))) {
    return;
  }
  await exec.run('opam', 'update', '--upgrade', '-y');
}

async function upgrade(): Promise<void> {
  await upgradeSystem();
  await upgradeFisher();
  await upgradeNpm();
  await upgradeRust();
  await upgradeCargo();
  await upgradeRimePlum();
  await upgradeGoInstall();
  await upgradeOpam();
}

await upgrade();

export default upgrade;
