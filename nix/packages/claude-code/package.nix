# Vendored claude-code: native binary fetched (hash-pinned) straight from
# Anthropic's CDN and wrapped locally. Hashes live in ./sources.json and are
# refreshed by ./update.sh. See ../vendored-cli.nix for the trust model.
{pkgs}: let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  mkVendoredCli = import ../vendored-cli.nix {inherit pkgs;};

  # Nix system → Anthropic release platform string.
  platforms = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  system = pkgs.stdenv.hostPlatform.system;
  platform =
    platforms.${system}
    or (throw "claude-code: unsupported system ${system}");
in
  mkVendoredCli {
    pname = "claude-code";
    binName = "claude";
    inherit (sources) version;

    src = pkgs.fetchurl {
      url = "https://downloads.claude.ai/claude-code-releases/${sources.version}/${platform}/claude";
      hash = sources.hashes.${system};
    };

    env = {
      DISABLE_AUTOUPDATER = "1";
      DISABLE_INSTALLATION_CHECKS = "1";
      USE_BUILTIN_RIPGREP = "0";
    };

    runtimeDeps =
      [pkgs.procps pkgs.ripgrep]
      ++ pkgs.lib.optionals pkgs.stdenv.isLinux [pkgs.bubblewrap pkgs.socat];
  }
