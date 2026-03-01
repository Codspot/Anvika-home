import type {
  AnyAgentTool,
  AnvikaPluginApi,
  AnvikaPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: AnvikaPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as AnvikaPluginToolFactory,
    { optional: true },
  );
}
