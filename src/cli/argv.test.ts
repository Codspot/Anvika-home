import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it.each([
    {
      name: "help flag",
      argv: ["node", "anvika", "--help"],
      expected: true,
    },
    {
      name: "version flag",
      argv: ["node", "anvika", "-V"],
      expected: true,
    },
    {
      name: "normal command",
      argv: ["node", "anvika", "status"],
      expected: false,
    },
    {
      name: "root -v alias",
      argv: ["node", "anvika", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with profile",
      argv: ["node", "anvika", "--profile", "work", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with log-level",
      argv: ["node", "anvika", "--log-level", "debug", "-v"],
      expected: true,
    },
    {
      name: "subcommand -v should not be treated as version",
      argv: ["node", "anvika", "acp", "-v"],
      expected: false,
    },
    {
      name: "root -v alias with equals profile",
      argv: ["node", "anvika", "--profile=work", "-v"],
      expected: true,
    },
    {
      name: "subcommand path after global root flags should not be treated as version",
      argv: ["node", "anvika", "--dev", "skills", "list", "-v"],
      expected: false,
    },
  ])("detects help/version flags: $name", ({ argv, expected }) => {
    expect(hasHelpOrVersion(argv)).toBe(expected);
  });

  it.each([
    {
      name: "single command with trailing flag",
      argv: ["node", "anvika", "status", "--json"],
      expected: ["status"],
    },
    {
      name: "two-part command",
      argv: ["node", "anvika", "agents", "list"],
      expected: ["agents", "list"],
    },
    {
      name: "terminator cuts parsing",
      argv: ["node", "anvika", "status", "--", "ignored"],
      expected: ["status"],
    },
  ])("extracts command path: $name", ({ argv, expected }) => {
    expect(getCommandPath(argv, 2)).toEqual(expected);
  });

  it.each([
    {
      name: "returns first command token",
      argv: ["node", "anvika", "agents", "list"],
      expected: "agents",
    },
    {
      name: "returns null when no command exists",
      argv: ["node", "anvika"],
      expected: null,
    },
  ])("returns primary command: $name", ({ argv, expected }) => {
    expect(getPrimaryCommand(argv)).toBe(expected);
  });

  it.each([
    {
      name: "detects flag before terminator",
      argv: ["node", "anvika", "status", "--json"],
      flag: "--json",
      expected: true,
    },
    {
      name: "ignores flag after terminator",
      argv: ["node", "anvika", "--", "--json"],
      flag: "--json",
      expected: false,
    },
  ])("parses boolean flags: $name", ({ argv, flag, expected }) => {
    expect(hasFlag(argv, flag)).toBe(expected);
  });

  it.each([
    {
      name: "value in next token",
      argv: ["node", "anvika", "status", "--timeout", "5000"],
      expected: "5000",
    },
    {
      name: "value in equals form",
      argv: ["node", "anvika", "status", "--timeout=2500"],
      expected: "2500",
    },
    {
      name: "missing value",
      argv: ["node", "anvika", "status", "--timeout"],
      expected: null,
    },
    {
      name: "next token is another flag",
      argv: ["node", "anvika", "status", "--timeout", "--json"],
      expected: null,
    },
    {
      name: "flag appears after terminator",
      argv: ["node", "anvika", "--", "--timeout=99"],
      expected: undefined,
    },
  ])("extracts flag values: $name", ({ argv, expected }) => {
    expect(getFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "anvika", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "anvika", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "anvika", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it.each([
    {
      name: "missing flag",
      argv: ["node", "anvika", "status"],
      expected: undefined,
    },
    {
      name: "missing value",
      argv: ["node", "anvika", "status", "--timeout"],
      expected: null,
    },
    {
      name: "valid positive integer",
      argv: ["node", "anvika", "status", "--timeout", "5000"],
      expected: 5000,
    },
    {
      name: "invalid integer",
      argv: ["node", "anvika", "status", "--timeout", "nope"],
      expected: undefined,
    },
  ])("parses positive integer flag values: $name", ({ argv, expected }) => {
    expect(getPositiveIntFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("builds parse argv from raw args", () => {
    const cases = [
      {
        rawArgs: ["node", "anvika", "status"],
        expected: ["node", "anvika", "status"],
      },
      {
        rawArgs: ["node-22", "anvika", "status"],
        expected: ["node-22", "anvika", "status"],
      },
      {
        rawArgs: ["node-22.2.0.exe", "anvika", "status"],
        expected: ["node-22.2.0.exe", "anvika", "status"],
      },
      {
        rawArgs: ["node-22.2", "anvika", "status"],
        expected: ["node-22.2", "anvika", "status"],
      },
      {
        rawArgs: ["node-22.2.exe", "anvika", "status"],
        expected: ["node-22.2.exe", "anvika", "status"],
      },
      {
        rawArgs: ["/usr/bin/node-22.2.0", "anvika", "status"],
        expected: ["/usr/bin/node-22.2.0", "anvika", "status"],
      },
      {
        rawArgs: ["node24", "anvika", "status"],
        expected: ["node24", "anvika", "status"],
      },
      {
        rawArgs: ["/usr/bin/node24", "anvika", "status"],
        expected: ["/usr/bin/node24", "anvika", "status"],
      },
      {
        rawArgs: ["node24.exe", "anvika", "status"],
        expected: ["node24.exe", "anvika", "status"],
      },
      {
        rawArgs: ["nodejs", "anvika", "status"],
        expected: ["nodejs", "anvika", "status"],
      },
      {
        rawArgs: ["node-dev", "anvika", "status"],
        expected: ["node", "anvika", "node-dev", "anvika", "status"],
      },
      {
        rawArgs: ["anvika", "status"],
        expected: ["node", "anvika", "status"],
      },
      {
        rawArgs: ["bun", "src/entry.ts", "status"],
        expected: ["bun", "src/entry.ts", "status"],
      },
    ] as const;

    for (const testCase of cases) {
      const parsed = buildParseArgv({
        programName: "anvika",
        rawArgs: [...testCase.rawArgs],
      });
      expect(parsed).toEqual([...testCase.expected]);
    }
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "anvika",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "anvika", "status"]);
  });

  it("decides when to migrate state", () => {
    const nonMutatingArgv = [
      ["node", "anvika", "status"],
      ["node", "anvika", "health"],
      ["node", "anvika", "sessions"],
      ["node", "anvika", "config", "get", "update"],
      ["node", "anvika", "config", "unset", "update"],
      ["node", "anvika", "models", "list"],
      ["node", "anvika", "models", "status"],
      ["node", "anvika", "memory", "status"],
      ["node", "anvika", "agent", "--message", "hi"],
    ] as const;
    const mutatingArgv = [
      ["node", "anvika", "agents", "list"],
      ["node", "anvika", "message", "send"],
    ] as const;

    for (const argv of nonMutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(false);
    }
    for (const argv of mutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(true);
    }
  });

  it.each([
    { path: ["status"], expected: false },
    { path: ["config", "get"], expected: false },
    { path: ["models", "status"], expected: false },
    { path: ["agents", "list"], expected: true },
  ])("reuses command path for migrate state decisions: $path", ({ path, expected }) => {
    expect(shouldMigrateStateFromPath(path)).toBe(expected);
  });
});
