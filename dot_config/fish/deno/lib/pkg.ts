import exec from "./exec.ts";

interface BrewPackageOpt {
  name: string;
  cask?: boolean;
  tap?: string;
}

type BrewPackage = string | BrewPackageOpt;
async function brewInstallPkg(
  name: string,
  cask = false,
  tap = "",
): Promise<void> {
  const installed = cask
    ? await exec.check("brew", "list", "--cask", "--version", name)
    : await exec.check("brew", "list", "--version", name);
  if (installed) {
    return;
  }
  if (tap !== "") {
    const tapped = await exec.check("fish", "-c", `brew tap | grep ${tap}`);
    if (!tapped) {
      await exec.run("brew", "tap", tap);
    }
  }
  if (cask) {
    await exec.run("brew", "install", "--cask", name);
  } else {
    await exec.run("brew", "install", name);
  }
}

async function brewInstall(...packages: BrewPackage[]): Promise<void> {
  for (const pkg of packages) {
    if (typeof pkg === "string") {
      await brewInstallPkg(pkg);
    } else {
      await brewInstallPkg(pkg.name, pkg.cask, pkg.tap);
    }
  }
}

async function brewUpgrade(): Promise<void> {
  await exec.run("brew", "update");
  await exec.run("brew", "upgrade");
  await exec.run("brew", "upgrade", "--cask");
  await exec.run("brew", "cleanup");
}

async function paruInstall(...packages: string[]): Promise<void> {
  await exec.run("paru", "-S", "--needed", "--noconfirm", ...packages);
}

async function paruUpgrade(): Promise<void> {
  await exec.run("paru", "-Syu", "--noconfirm");
}

async function flatpakUpgrade(): Promise<void> {
  await exec.run("sudo", "flatpak", "upgrade", "-y");
}

async function homeManagerUpgrade(): Promise<void> {
  await exec.runWithOptions(["nix", "flake", "update"], {
    cwd: Deno.env.get("XDG_CONFIG_HOME") + "/home-manager",
  });
  await exec.run("home-manager", "switch");
}

export default {
  brewInstall,
  brewUpgrade,
  paruInstall,
  paruUpgrade,
  flatpakUpgrade,
  homeManagerUpgrade,
};
