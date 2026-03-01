export const SUPERVISOR_HINT_ENV_VARS = [
  // macOS launchd
  "LAUNCH_JOB_LABEL",
  "LAUNCH_JOB_NAME",
  // Anvika service env markers
  "ANVIKA_LAUNCHD_LABEL",
  "ANVIKA_SYSTEMD_UNIT",
  "ANVIKA_SERVICE_MARKER",
  // Linux systemd
  "INVOCATION_ID",
  "SYSTEMD_EXEC_PID",
  "JOURNAL_STREAM",
] as const;

export function hasSupervisorHint(env: NodeJS.ProcessEnv = process.env): boolean {
  return SUPERVISOR_HINT_ENV_VARS.some((key) => {
    const value = env[key];
    return typeof value === "string" && value.trim().length > 0;
  });
}
