{pkgs, ...}: let
  version = "0.18.0";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-${version}.tgz";
    hash = "sha256-TZsDZ20GsurSPB4WZse8omQMOZkrba4IbrQHoYfgHNk=";
  };

  # The published bundle (dist/main.mjs) externalises its optionalDependencies
  # instead of bundling them, so they must live in a node_modules next to the
  # bundle. Some are native (koffi, node-pty), so we let npm resolve and build
  # them from the pinned package-lock.json. The dependency set mirrors
  # @moonshot-ai/kimi-code's optionalDependencies — exactly what
  # `brew install kimi-code` / `npm install` would pull in.
  #
  # To bump: update version + src hash, regenerate package-lock.json from the
  # new optionalDependencies, then update npmDepsHash via
  # `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
  nodeModules = pkgs.buildNpmPackage {
    pname = "kimi-code-node-modules";
    inherit version;
    src = ./.;
    npmDepsHash = "sha256-JoHDR6OXNvS/RpiFix0s2lILtAcHi4D2b/WrNQo/Fps=";

    # No package of our own to build; we only want the resolved node_modules.
    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      runHook postInstall
    '';
  };

  kimi-code = pkgs.stdenv.mkDerivation {
    pname = "kimi-code";
    inherit version src;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/kimi-code $out/bin
      cp -r . $out/lib/kimi-code
      ln -s ${nodeModules}/node_modules $out/lib/kimi-code/node_modules
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/kimi \
        --add-flags $out/lib/kimi-code/dist/main.mjs
      runHook postInstall
    '';

    meta = {
      description = "AI coding agent for your terminal";
      homepage = "https://moonshotai.github.io/kimi-code/";
      mainProgram = "kimi";
    };
  };
in {
  home.packages = [kimi-code];
}
