{
  config,
  pkgs,
  rootDir,
  llm-agents,
  ...
}: let
  managedSkills = pkgs.python3Packages.buildPythonApplication {
    pname = "managed-skills";
    version = "0.1.0";
    pyproject = true;
    src = ./managed-skills;

    build-system = [pkgs.python3Packages.setuptools];
    dependencies = [pkgs.python3Packages.pyyaml];
    nativeCheckInputs = [
      pkgs.python3Packages.pytestCheckHook
      pkgs.ruff
    ];
    doCheck = true;
    preCheck = "ruff check src tests";
    pytestFlags = ["tests"];
    pythonImportsCheck = ["managed_skills"];

    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (pkgs.lib.makeBinPath [llm-agents.skills])
    ];
  };
in {
  # The shared policy is repo-managed. Machine-local repository bindings and
  # project destinations live alongside it in unmanaged local.yaml.
  xdg.configFile."skills/skills.yaml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${rootDir}/config/dot_config/skills/skills.yaml";

  home.packages = [
    # vercel-labs/skills: the open agent skills tool for installing and managing
    # skills across AI coding agents. Pulled prebuilt from llm-agents.nix.
    llm-agents.skills
    managedSkills
  ];
}
