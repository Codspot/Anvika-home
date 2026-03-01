import { vi } from "vitest";
import { installChromeUserDataDirHooks } from "./chrome-user-data-dir.test-harness.js";

const chromeUserDataDir = { dir: "/tmp/anvika" };
installChromeUserDataDirHooks(chromeUserDataDir);

vi.mock("./chrome.js", () => ({
  isChromeCdpReady: vi.fn(async () => true),
  isChromeReachable: vi.fn(async () => true),
  launchAnvikaChrome: vi.fn(async () => {
    throw new Error("unexpected launch");
  }),
  resolveAnvikaUserDataDir: vi.fn(() => chromeUserDataDir.dir),
  stopAnvikaChrome: vi.fn(async () => {}),
}));
