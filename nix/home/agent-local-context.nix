{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "agent-local-context";
      runtimeInputs = [
        pkgs.git
        pkgs.jq
      ];
      text = builtins.readFile ../../config/scripts/agent-local-context;
    })
  ];
}
