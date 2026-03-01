import type { AnvikaPluginApi } from "anvika/plugin-sdk";
import { emptyPluginConfigSchema } from "anvika/plugin-sdk";
import { createDiagnosticsOtelService } from "./src/service.js";

const plugin = {
  id: "diagnostics-otel",
  name: "Diagnostics OpenTelemetry",
  description: "Export diagnostics events to OpenTelemetry",
  configSchema: emptyPluginConfigSchema(),
  register(api: AnvikaPluginApi) {
    api.registerService(createDiagnosticsOtelService());
  },
};

export default plugin;
