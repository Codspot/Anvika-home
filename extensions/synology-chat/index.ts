import type { AnvikaPluginApi } from "anvika/plugin-sdk";
import { emptyPluginConfigSchema } from "anvika/plugin-sdk";
import { createSynologyChatPlugin } from "./src/channel.js";
import { setSynologyRuntime } from "./src/runtime.js";

const plugin = {
  id: "synology-chat",
  name: "Synology Chat",
  description: "Native Synology Chat channel plugin for Anvika",
  configSchema: emptyPluginConfigSchema(),
  register(api: AnvikaPluginApi) {
    setSynologyRuntime(api.runtime);
    api.registerChannel({ plugin: createSynologyChatPlugin() });
  },
};

export default plugin;
