# Launch Zed with a Zed-only PATH.
#
# When launched from a shell, Zed inherits that shell's environment and
# passes its PATH on to language servers and linters. By prepending the
# Zed-only tool directory here, Zed can find those tools without exposing
# them on the interactive shell's PATH. Tools are defined in nix/home/zed.nix.
#
# Prefer Zed's own CLI launcher if it's installed: Zed > "Install CLI" drops it
# at /usr/local/bin/zed. That binary forks the app and returns immediately, so
# there are no foreground logs and the env is passed through to the spawned Zed
# -- just call it directly.
#
# Otherwise fall back to whatever `zed` is on PATH (e.g. brew-nix's `bin/zed`,
# which execs the GUI binary in the foreground and spews logs): detach it with
# zsh's `&!` (background + disown) so it survives the shell, and drop the log
# noise with `&>/dev/null` (Zed still writes its own log file).
#
# Caveats: this only applies when Zed is started from the terminal (`zed .`),
# not from Dock/Spotlight. Zed is single-instance, so the first launch wins.
zed() {
  local tools="${XDG_DATA_HOME:-$HOME/.local/share}/zed-tools/bin"
  if [[ -x /usr/local/bin/zed ]]; then
    PATH="$tools:$PATH" /usr/local/bin/zed "$@"
  else
    PATH="$tools:$PATH" command zed "$@" &>/dev/null &!
  fi
}
