{pkgs, ...}: {
  # Record exact resume commands for live agent CLIs in a Zed scratchpad.
  # Source: config/scripts/zed-agent-sessions
  home.packages = [
    (pkgs.writeShellApplication {
      name = "zed-agent-sessions";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        gnused
        jq
        lsof
      ];
      text = builtins.readFile ../../config/scripts/zed-agent-sessions;
    })
  ];
}
