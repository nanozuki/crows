import exec from "./lib/exec.ts";
import fish from "./lib/fish.ts";
import { isMacOS } from "./lib/os.ts";
import pkg from "./lib/pkg.ts";
import plum from "./lib/plum.ts";

// initFish to fit the config.fish
async function initFish(): Promise<void> {
  if (await fish.hasCommand("fisher")) {
    return;
  }
  await fish.installFisher();
  await fish.installPlugins(
    "jethrokuan/z",
    "PatrickF1/fzf.fish",
    "lilyball/nix-env.fish",
  );
}

async function initRime(): Promise<void> {
  if (await plum.isIstalled()) {
    return;
  }
  if (isMacOS) {
    pkg.brewInstall({ name: "squirrel", cask: true });
  } else {
    pkg.paruInstall("fcitx5-rime");
  }
  await plum.install();
}

async function initRust(): Promise<void> {
  if (await fish.hasCommand("cargo")) {
    return;
  }
  await fish.setVar("CARGO_HOME", "$XDG_DATA_HOME/cargo");
  await fish.setVar("RUSTUP_HOME", "$XDG_DATA_HOME/rustup");
  await fish.addPath(["$CARGO_HOME/bin"]);
  if (isMacOS) {
    await pkg.brewInstall("rustup");
    await exec.run("rustup-init");
  } else {
    await exec.run("sudo", "pacman", "-S", "--needed", "--noconfirm", "rustup");
    await exec.run("rustup", "toolchain", "install", "stable");
    await exec.run("rustup", "default", "stable");
  }
}

async function initOCaml(): Promise<void> {
  if (await fish.hasCommand("opam")) {
    return;
  }
  await fish.setVar("OPAMROOT", "$XDG_DATA_HOME/opam");
  if (isMacOS) {
    await pkg.brewInstall("opam");
  } else {
    await pkg.paruInstall("opam");
  }
  await exec.run("opam", "init", "--disable-shell-hook");
}

const allItems = new Map<string, () => Promise<void>>();
allItems.set("fish", initFish);
allItems.set("rime", initRime);
allItems.set("rust", initRust);
allItems.set("ocaml", initOCaml);

async function init(): Promise<void> {
  if (Deno.args.length === 0) {
    const items = Array.from(allItems.keys());
    console.log("Please specify the init item(s)");
    console.log(`All items are: ${items}`);
  }
  for (const item of Deno.args) {
    const initFn = allItems.get(item);
    if (initFn) {
      console.log(`Init ${item}`);
      await initFn();
    } else {
      console.log(`Unknown Item ${item}, Skip.`);
    }
  }
}

await init();
