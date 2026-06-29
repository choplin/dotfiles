{pkgs, ...}: {
  # Tools exposed only to Zed, intentionally kept off the global PATH.
  #
  # The `zed` shell function in config/dot_zsh/zed.zsh prepends this bin
  # directory to PATH when launching Zed from a terminal (`zed .`), so its
  # language servers and linters resolve here while the interactive shell's
  # PATH stays clean. Only applies to terminal launches, not Dock/Spotlight.
  # Add LSPs / linters as needed.
  xdg.dataFile."zed-tools".source = pkgs.buildEnv {
    name = "zed-tools";
    paths = with pkgs; [
      nixd
      alejandra
      metals
      jdk
      go
      gopls
      nil
    ];
  };
}
