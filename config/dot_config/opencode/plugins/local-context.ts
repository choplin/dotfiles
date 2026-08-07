import type { Plugin } from "@opencode-ai/plugin"

const localContextPath = ".agents/local-context.md"

export const LocalContextPlugin: Plugin = async ({ worktree }) => {
  const contextFile = Bun.file(`${worktree}/${localContextPath}`)

  if (!(await contextFile.exists())) {
    return {}
  }

  const context = await contextFile.text()

  if (context.trim() === "") {
    return {}
  }

  return {
    "experimental.chat.system.transform": async (_input, output) => {
      output.system.push(
        `Repository-local context loaded from ${contextFile.name}:\n\n${context}`,
      )
    },
  }
}
