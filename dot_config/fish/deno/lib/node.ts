import exec from "./exec.ts";

interface NpmListItem {
  version: string;
  overridden: boolean;
}

interface NpmList {
  name: string;
  dependencies: Record<string, NpmListItem>;
}

async function npmPkgUpgrade(): Promise<void> {
  const listJSON = await exec.output("npm", "-g", "list", "--json");
  const list: NpmList = JSON.parse(listJSON);
  for (const key in list.dependencies) {
    console.log(`upgrade npm package: ${key}`);
    await exec.run("npm", "-g", "install", key);
  }
}

async function npmPkgInstall(...pkgs: string[]): Promise<void> {
  await exec.run("npm", "--location=global", "install", ...pkgs);
}

export default {
  npmPkgUpgrade,
  npmPkgInstall,
};
