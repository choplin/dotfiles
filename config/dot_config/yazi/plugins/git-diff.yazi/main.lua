--- @since 26.1.22

-- Previewer that shows a colored `git diff` (via delta) for files listed in the
-- `git-files` plugin's "Git status files" search view, and falls back to the
-- normal previewer everywhere else.

local M = {}

-- The search keyword used by the `git-files` plugin when building its view.
-- Files in that view carry this as their Url `domain`.
local GIT_FILES_DOMAIN = "Git status files"

-- Shell pipeline: diff the hovered file (tracked: vs HEAD, untracked: vs
-- /dev/null) and colorize it with delta. $1 is the file path, $w is the width.
-- The extra delta config forces a unified (context) diff: yazi already splits
-- the screen into panes, so delta's own side-by-side view would be too narrow.
local DIFF_CMD = [[
p=$1
cd "$(dirname "$p")" 2>/dev/null || exit 0
if git ls-files --error-unmatch -- "$p" >/dev/null 2>&1; then
	git diff HEAD -- "$p"
else
	git diff --no-index -- /dev/null "$p" 2>/dev/null
fi | delta --width="${w:-80}" --paging=never \
	--config "${XDG_CONFIG_HOME:-$HOME/.config}/delta/context.gitconfig"
]]

local function is_git_files(job)
	local url = job.file.url
	return url.is_search and url.domain == GIT_FILES_DOMAIN
end

local function fail(job, s)
	ya.preview_widget(job, ui.Text.parse(s):area(job.area):wrap(ui.Wrap.YES))
end

function M:peek(job)
	if not is_git_files(job) then
		return require(job.args[1] or "code"):peek(job)
	end

	local child, err = Command("sh")
		:arg({ "-c", DIFF_CMD, "sh", tostring(job.file.url.path) })
		:env("w", job.area.w)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return fail(job, "sh: " .. err)
	end

	local limit = job.area.h
	local i, outs, errs = 0, {}, {}
	repeat
		local next, event = child:read_line()
		if event == 1 then
			errs[#errs + 1] = next
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			outs[#outs + 1] = next
		end
	until i >= job.skip + limit

	child:start_kill()
	if #errs > 0 then
		fail(job, table.concat(errs, ""))
	elseif job.skip > 0 and i < job.skip + limit then
		ya.emit("peek", { math.max(0, i - limit), only_if = job.file.url, upper_bound = true })
	else
		ya.preview_widget(job, ui.Text.parse(table.concat(outs, "")):area(job.area))
	end
end

function M:seek(job) require("code"):seek(job) end

return M
