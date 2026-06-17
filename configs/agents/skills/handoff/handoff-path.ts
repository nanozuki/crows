#!/usr/bin/env node

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { execFileSync } from "node:child_process";

type ObsidianVault = {
  path?: unknown;
};

type ObsidianConfig = {
  vaults?: Record<string, ObsidianVault>;
};

function fail(message: string): never {
  console.error(message);
  process.exit(1);
}

function git(args: string[], failureMessage: string): string {
  try {
    return execFileSync("git", args, {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch {
    fail(failureMessage);
  }
}

function obsidianConfigPath(): string {
  if (process.platform === "darwin") {
    return path.join(
      os.homedir(),
      "Library",
      "Application Support",
      "obsidian",
      "obsidian.json",
    );
  }

  const configHome = process.env.XDG_CONFIG_HOME ?? path.join(os.homedir(), ".config");
  return path.join(configHome, "obsidian", "obsidian.json");
}

function firstVaultPath(): string {
  const configPath = obsidianConfigPath();

  let config: ObsidianConfig;
  try {
    config = JSON.parse(fs.readFileSync(configPath, "utf8")) as ObsidianConfig;
  } catch (error) {
    fail(`could not read Obsidian config at ${configPath}: ${errorMessage(error)}`);
  }

  const vault = Object.values(config.vaults ?? {}).find(
    (candidate) => typeof candidate.path === "string" && candidate.path.length > 0,
  );

  if (!vault || typeof vault.path !== "string") {
    fail(`could not determine first Obsidian vault from ${configPath}`);
  }

  return vault.path;
}

function remoteKey(remoteUrl: string): string {
  return remoteUrl
    .replace(/^git@/, "")
    .replace(/^https:\/\//, "")
    .replace(/\.git$/, "")
    .replaceAll(":", "/");
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}

git(["rev-parse", "--is-inside-work-tree"], "not inside a git repository");

const branch = git(["branch", "--show-current"], "could not determine current branch");
if (branch.length === 0) {
  fail("repository is in detached HEAD or has no current branch");
}

const remoteUrl = git(["remote", "get-url", "origin"], "repository has no origin remote URL");
if (remoteUrl.length === 0) {
  fail("repository has no origin remote URL");
}

const notePath = path.join(
  firstVaultPath(),
  "Logbook",
  encodeURIComponent(remoteKey(remoteUrl)),
  `${encodeURIComponent(branch)}.md`,
);

console.log(notePath);
