# Vendored codex (OpenAI Codex CLI): native binary fetched (hash-pinned)
# straight from openai/codex GitHub release tarballs and wrapped locally.
# Hashes live in ./sources.json and are refreshed by ./update.sh.
# See ../vendored-cli.nix for the trust model.
{pkgs}: let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  mkVendoredCli = import ../vendored-cli.nix {inherit pkgs;};

  # Nix system → Rust target triple used in the release asset name.
  triples = {
    aarch64-darwin = "aarch64-apple-darwin";
    x86_64-darwin = "x86_64-apple-darwin";
    x86_64-linux = "x86_64-unknown-linux-musl";
    aarch64-linux = "aarch64-unknown-linux-musl";
  };
  system = pkgs.stdenv.hostPlatform.system;
  triple =
    triples.${system}
    or (throw "codex: unsupported system ${system}");
in
  mkVendoredCli {
    pname = "codex";
    inherit (sources) version;

    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${sources.version}/codex-${triple}.tar.gz";
      hash = sources.hashes.${system};
    };
    unpack = true;
    binPath = "codex-${triple}";

    env.DISABLE_AUTOUPDATER = "1";
    # Point codex at its own real binary so it never tries to self-update.
    extraWrapperFlags = "--set CODEX_EXECUTABLE_PATH $out/libexec/codex-unwrapped";

    runtimeDeps = pkgs.lib.optionals pkgs.stdenv.isLinux [pkgs.bubblewrap];
  }
