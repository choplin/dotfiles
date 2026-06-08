{...}: {
  # Tailscale daemon — auto-starts at boot so the host stays reachable on the
  # tailnet without requiring an interactive GUI login.
  # First-time setup: run `sudo tailscale up` once to authenticate this node.
  services.tailscale.enable = true;

  # Enable macOS's built-in OpenSSH server (equivalent to System Settings →
  # General → Sharing → Remote Login). Needed for plain `ssh` and for mosh's
  # initial handshake. nix-darwin toggles the launchd job directly, so this
  # avoids the Full Disk Access requirements of `systemsetup -setremotelogin`.
  services.openssh.enable = true;
}
