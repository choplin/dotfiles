# Launch Zed with a Zed-only PATH.
#
# When launched from a shell, Zed inherits that shell's environment and
# passes its PATH on to language servers and linters. By prepending the
# Zed-only tool directory here, Zed can find those tools without exposing
# them on the interactive shell's PATH. Tools are defined in nix/home/zed.nix.
#
# Caveats: this only applies when Zed is started from the terminal (`zed .`),
# not from Dock/Spotlight. Zed is single-instance, so the first launch wins.
zed() {
  PATH="${XDG_DATA_HOME:-$HOME/.local/share}/zed-tools/bin:$PATH" command zed "$@"
}
