async function run(...cmd: string[]): Promise<void> {
  const args = cmd.length > 1 ? cmd.slice(1) : undefined;
  const command = new Deno.Command(cmd[0], {
    args,
    stderr: "piped",
    stdout: "inherit",
    stdin: "inherit",
  });
  const { success, code, stderr } = await command.output();
  if (!success) {
    const errorString = new TextDecoder().decode(stderr);
    throw new Error(
      `Execute '${cmd.join(" ")}' failed(${code}):\n${errorString}`
    );
  }
}

async function check(...cmd: string[]): Promise<boolean> {
  const args = cmd.length > 1 ? cmd.slice(1) : undefined;
  const command = new Deno.Command(cmd[0], {
    args,
    stdout: "piped",
    stderr: "piped",
  });
  const { success } = await command.output();
  return success;
}

async function output(...cmd: string[]): Promise<string> {
  const args = cmd.length > 1 ? cmd.slice(1) : undefined;
  const command = new Deno.Command(cmd[0], {
    args,
    stdout: "piped",
    stderr: "piped",
  });
  const { success, code, stdout, stderr } = await command.output();
  if (!success) {
    const errorString = new TextDecoder().decode(stderr);
    throw new Error(
      `Execute '${cmd.join(" ")}' failed(${code}):\n${errorString}`
    );
  }
  const outString = new TextDecoder().decode(stdout);
  return outString.trim();
}

export default {
  run,
  check,
  output,
};
