import exec from './exec.ts';

async function hasCommand(name: string): Promise<boolean> {
  const has = await exec.check('fish', '-c', `type -q ${name}`);
  return has;
}

async function hasDir(name: string): Promise<boolean> {
  const has = await exec.check('fish', '-c', `test -d ${name}`);
  return has;
}

async function setVar(key: string, value: string): Promise<string> {
  await exec.run('fish', '-c', `set -Ux ${key} ${value}`);
  const vvalue = await exec.output('fish', '-c', `echo $${key}`);
  Deno.env.set(key, vvalue);
  return vvalue;
}

async function setPath(values: string[]): Promise<string> {
  const cmd = `set -Ux fish_user_paths ${values.join(' ')}`;
  await exec.run('fish', '-c', cmd);
  const vvalue = await exec.output('fish', '-c', `echo $PATH`);
  Deno.env.set('PATH', vvalue);
  return vvalue;
}

async function addPath(values: string[]): Promise<string> {
  const cmd = `fish_add_path ${values.join(' ')}; or return 0`; // ignore duplicated error
  await exec.run('fish', '-c', cmd);
  const vvalue = await exec.output('fish', '-c', `echo $PATH`);
  Deno.env.set('PATH', vvalue);
  return vvalue;
}

async function installFisher() {
  const cmd =
    'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher';
  await exec.run('fish', '-c', cmd);
}

async function installPlugins(...plugins: string[]): Promise<void> {
  for (const plugin of plugins) {
    await exec.run('fish', '-c', `fisher install ${plugin}`);
  }
}

async function upgradePlugins(): Promise<void> {
  await exec.run('fish', '-c', 'fisher update');
}

export default {
  hasCommand,
  hasDir,
  setVar,
  setPath,
  addPath,
  installFisher,
  installPlugins,
  upgradePlugins,
};
