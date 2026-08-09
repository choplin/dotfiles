import type { Plugin } from "@opencode-ai/plugin"
import { mkdir } from "node:fs/promises"

const localContextPath = ".agents/local-context.md"

export const LocalContextPlugin: Plugin = async ({ worktree }) => {
  const contextFile = Bun.file(`${worktree}/${localContextPath}`)
  const context = (await contextFile.exists()) ? await contextFile.text() : ""

  return {
    "chat.params": async (input) => {
      const home = process.env.HOME
      if (!home) {
        return
      }

      const stateHome = process.env.XDG_STATE_HOME ?? `${home}/.local/state`
      const sessionDirectory = `${stateHome}/zed-agent-sessions/opencode`
      await mkdir(sessionDirectory, { recursive: true })
      await Bun.write(
        `${sessionDirectory}/${process.pid}.json`,
        JSON.stringify({
          pid: process.pid,
          sessionId: input.sessionID,
          cwd: worktree,
        }),
      )
    },
    "experimental.chat.system.transform": async (_input, output) => {
      if (context.trim() !== "") {
        output.system.push(
          `Repository-local context loaded from ${contextFile.name}:\n\n${context}`,
        )
      }
    },
  }
}
