async function run(...cmd: string[]): Promise<void> {
  const p = Deno.run({ cmd, stderr: 'piped' });
  const [{ code }, rawError] = await Promise.all([
    p.status(),
    p.stderrOutput(),
  ]);
  if (code != 0) {
    const errorString = new TextDecoder().decode(rawError);
    throw new Error(`error(${code}): ${errorString}`);
  }
}

async function check(...cmd: string[]): Promise<boolean> {
  const p = Deno.run({ cmd, stdin: 'piped', stdout: 'piped', stderr: 'piped' });
  const status = await p.status();
  return status.success;
}

async function output(...cmd: string[]): Promise<string> {
  const p = Deno.run({ cmd, stdout: 'piped', stderr: 'piped' });
  const [{ code }, rawOutput, rawError] = await Promise.all([
    p.status(),
    p.output(),
    p.stderrOutput(),
  ]);
  if (code != 0) {
    const errorString = new TextDecoder().decode(rawError);
    throw new Error(`error(${code}): ${errorString}`);
  }
  const outString = new TextDecoder().decode(rawOutput);
  return outString.trim();
}

export default {
  run,
  check,
  output,
};
