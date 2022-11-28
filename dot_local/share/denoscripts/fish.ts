async function setUx(key: string, ...value: string[]) {
  const p = Deno.run({
    cmd: ['fish', '-c', `set -Ux ${key} ${value.join(' ')}`],
  });
  const status = await p.status();
  if (!status.success) {
    throw Error(status.code.toString());
  }
}

async function addPath(...path: string[]) {
  const p = Deno.run({
    cmd: ['fish', '-c', `fish_add_path ${path.join(' ')}`],
  });
  const status = await p.status();
  if (!status.success) {
    throw Error(status.code.toString());
  }
}

async function ifExist(name: string): Promise<boolean> {
  const p = Deno.run({ cmd: ['fish', 'type', '-q', name] });
  const status = await p.status();
  return status.success;
}

async function installFisher() {
  if (await ifExist('fisher')) {
    return;
  }
  const cmd =
    'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher';
  const p = Deno.run({ cmd: ['fish', '-c', cmd] });
  const status = await p.status();
  if (!status.success) {
    throw Error(status.code.toString());
  }
}

export default { setUx, addPath, ifExist, installFisher };
