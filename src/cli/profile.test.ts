import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "anvika",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "anvika", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "anvika", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "anvika", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "anvika", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "anvika", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "anvika", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it.each([
    ["--dev first", ["node", "anvika", "--dev", "--profile", "work", "status"]],
    ["--profile first", ["node", "anvika", "--profile", "work", "--dev", "status"]],
  ])("rejects combining --dev with --profile (%s)", (_name, argv) => {
    const res = parseCliProfileArgs(argv);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join(path.resolve("/home/peter"), ".anvika-dev");
    expect(env.ANVIKA_PROFILE).toBe("dev");
    expect(env.ANVIKA_STATE_DIR).toBe(expectedStateDir);
    expect(env.ANVIKA_CONFIG_PATH).toBe(path.join(expectedStateDir, "anvika.json"));
    expect(env.ANVIKA_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      ANVIKA_STATE_DIR: "/custom",
      ANVIKA_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.ANVIKA_STATE_DIR).toBe("/custom");
    expect(env.ANVIKA_GATEWAY_PORT).toBe("19099");
    expect(env.ANVIKA_CONFIG_PATH).toBe(path.join("/custom", "anvika.json"));
  });

  it("uses ANVIKA_HOME when deriving profile state dir", () => {
    const env: Record<string, string | undefined> = {
      ANVIKA_HOME: "/srv/anvika-home",
      HOME: "/home/other",
    };
    applyCliProfileEnv({
      profile: "work",
      env,
      homedir: () => "/home/fallback",
    });

    const resolvedHome = path.resolve("/srv/anvika-home");
    expect(env.ANVIKA_STATE_DIR).toBe(path.join(resolvedHome, ".anvika-work"));
    expect(env.ANVIKA_CONFIG_PATH).toBe(
      path.join(resolvedHome, ".anvika-work", "anvika.json"),
    );
  });
});

describe("formatCliCommand", () => {
  it.each([
    {
      name: "no profile is set",
      cmd: "anvika doctor --fix",
      env: {},
      expected: "anvika doctor --fix",
    },
    {
      name: "profile is default",
      cmd: "anvika doctor --fix",
      env: { ANVIKA_PROFILE: "default" },
      expected: "anvika doctor --fix",
    },
    {
      name: "profile is Default (case-insensitive)",
      cmd: "anvika doctor --fix",
      env: { ANVIKA_PROFILE: "Default" },
      expected: "anvika doctor --fix",
    },
    {
      name: "profile is invalid",
      cmd: "anvika doctor --fix",
      env: { ANVIKA_PROFILE: "bad profile" },
      expected: "anvika doctor --fix",
    },
    {
      name: "--profile is already present",
      cmd: "anvika --profile work doctor --fix",
      env: { ANVIKA_PROFILE: "work" },
      expected: "anvika --profile work doctor --fix",
    },
    {
      name: "--dev is already present",
      cmd: "anvika --dev doctor",
      env: { ANVIKA_PROFILE: "dev" },
      expected: "anvika --dev doctor",
    },
  ])("returns command unchanged when $name", ({ cmd, env, expected }) => {
    expect(formatCliCommand(cmd, env)).toBe(expected);
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("anvika doctor --fix", { ANVIKA_PROFILE: "work" })).toBe(
      "anvika --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("anvika doctor --fix", { ANVIKA_PROFILE: "  jbanvika  " })).toBe(
      "anvika --profile jbanvika doctor --fix",
    );
  });

  it("handles command with no args after anvika", () => {
    expect(formatCliCommand("anvika", { ANVIKA_PROFILE: "test" })).toBe(
      "anvika --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm anvika doctor", { ANVIKA_PROFILE: "work" })).toBe(
      "pnpm anvika --profile work doctor",
    );
  });
});
