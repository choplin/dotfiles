{pkgs, lib, ...}: let
  editorTools = import ./editor-language-tools.nix {inherit pkgs lib;};

  # Shared common-language tools plus Zed-only extras kept off the global PATH.
  # JVM tools (Metals/JDK) are intentionally omitted — Scala/Java/Kotlin are out of scope.
  # nodejs supplies `npx` for mcp-remote context servers in settings.json.
  zedTools = editorTools.mkEditorToolsEnv {
    name = "zed-tools";
    languages = editorTools.commonLanguages;
    extraPackages = with pkgs; [
      nodejs
    ];
  };
in {
  # The `zed` shell function in config/dot_zsh/zed.zsh appends this bin
  # directory to PATH when launching Zed from a terminal (`zed .`), so its
  # language servers and linters resolve here while the interactive shell's
  # PATH stays clean. Only applies to terminal launches, not Dock/Spotlight.
  xdg.dataFile."zed-tools".source = zedTools;
}
