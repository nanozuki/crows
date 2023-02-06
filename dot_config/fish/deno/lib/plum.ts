import fish from './fish.ts';
import exec from './exec.ts';
import { isMacOS } from './os.ts';

const plumRepo = 'https://github.com/rime/plum.git $XDG_DATA_HOME/plum';
const plumDir = '$XDG_DATA_HOME/plum';
const plumScript = '$XDG_DATA_HOME/plum/rime-install';

async function isIstalled(): Promise<boolean> {
  const installed = await fish.hasDir(plumDir);
  return installed;
}

async function install(): Promise<void> {
  if (!isMacOS) {
    await fish.setVar('rime_frontend', 'fcitx5-rime');
  }
  await exec.run('git', 'clone', '--depth', '1', plumRepo, plumDir);
  await upgrade();
}

async function upgrade(): Promise<void> {
  await exec.run('bash', '-c', `${plumScript} prelude`);
  await exec.run('bash', '-c', `${plumScript} essay`);
  await exec.run('bash', '-c', `${plumScript} luna-pinyin`);
  await exec.run('bash', '-c', `${plumScript} double-pinyin`);
  await exec.run('bash', '-c', `${plumScript} emoji`);
}

export default {
  isIstalled,
  install,
  upgrade,
};
