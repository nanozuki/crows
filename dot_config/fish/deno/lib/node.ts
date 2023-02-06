import exec from './exec.ts';
import fish from './fish.ts';
import { isMacOS } from './os.ts';
import pkg from './pkg.ts';

interface NodeVersion {
  ltsCode: string;
  ltsVersion: number;
  currentVersion: number;
}

interface IndexItem {
  version: string;
  date: string;
  lts: string | boolean;
}

const extractVersion = (versionStr: string): number =>
  Number(versionStr.split('.')[0].substring(1));

async function fetchVersion(): Promise<NodeVersion> {
  const indexURL = 'https://nodejs.org/download/release/index.json';
  const index: IndexItem[] = await (await fetch(indexURL)).json();

  const currentVersion = extractVersion(index[0].version);
  let [ltsVersion, ltsCode] = [0, ''];
  for (let i = 0; i < index.length; i++) {
    if (typeof index[i].lts === 'string') {
      ltsVersion = extractVersion(index[i].version);
      ltsCode = index[i].lts as string;
      break;
    }
  }

  return { ltsCode, ltsVersion, currentVersion };
}

async function installedVersion(): Promise<number> {
  const ver = extractVersion(await exec.output('node', '-v'));
  return ver;
}

async function checkVersion(): Promise<boolean> {
  const nodeVer = await fetchVersion();
  const installedVer = await installedVersion();
  if (installedVer === nodeVer.currentVersion) {
    console.log(`Using Current nodejs: Node ${nodeVer.currentVersion}`);
    return true;
  } else if (installedVer == nodeVer.ltsVersion) {
    console.log(
      `Using LTS nodejs: Node ${nodeVer.ltsVersion} ${nodeVer.ltsCode}.`
    );
    return true;
  } else {
    console.log(
      `Node version ${installedVer} is outdated, need to be upgrade.`
    );
    console.log(`Current: Node ${nodeVer.currentVersion}`);
    console.log(`LTS: Node ${nodeVer.ltsVersion} ${nodeVer.ltsCode}`);
    return false;
  }
}

async function installLTS(): Promise<void> {
  const ver = await fetchVersion();
  fish.setVar('NPM_CONFIG_USERCONFIG', '$XDG_CONFIG_HOME/npm/npmrc');
  fish.addPath(['$XDG_DATA_HOME/npm/bin']);
  if (isMacOS) {
    await pkg.brewInstall(`node@${ver.ltsVersion}`);
    await exec.run('brew', '--overwrite', '--force', `node@${ver.ltsVersion}`);
  } else {
    await pkg.paruInstall(`nodejs-lts-${ver.ltsCode.toLowerCase()}`);
  }
  const prefix = `${Deno.env.get('XDG_DATA_HOME')}/npm`;
  const cache = `${Deno.env.get('XDG_CACHE_HOME')}/npm`;
  const init = `${Deno.env.get('XDG_CONFIG_HOME')}/npm/config/npm-init.js`;
  await exec.run('npm', 'config', 'set', 'prefix', prefix);
  await exec.run('npm', 'config', 'set', 'cache', cache);
  await exec.run('npm', 'config', 'set', 'init-module', init);
}

interface NpmListItem {
  version: string;
  overridden: boolean;
}

interface NpmList {
  name: string;
  dependencies: Record<string, NpmListItem>;
}

async function npmPkgUpgrade(): Promise<void> {
  const listJSON = await exec.output('npm', '-g', 'list', '--json');
  const list: NpmList = JSON.parse(listJSON);
  for (const key in list.dependencies) {
    console.log(`upgrade npm package: ${key}`);
    await exec.run('npm', '-g', 'install', key);
  }
}

async function npmPkgInstall(...pkgs: string[]): Promise<void> {
  await exec.run('npm', '--location=global', 'install', ...pkgs);
}

export default {
  checkVersion,
  installLTS,
  npmPkgUpgrade,
  npmPkgInstall,
};
