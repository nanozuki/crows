import exec from './exec.ts';

const isMacOS = (await exec.output('uname', '-s')) === 'Darwin';

export { isMacOS };
