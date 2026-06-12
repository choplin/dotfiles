# Generic builder for a vendored CLI distributed as a prebuilt, per-platform
# artifact (raw binary or tarball) from an upstream vendor.
#
# Trust model: the per-platform sha256 lives in the caller's pinned
# sources.json and is computed locally by that tool's update.sh straight from
# the vendor (never taken from any third-party packaging). This derivation
# only fetches the hash-pinned artifact and wraps it; no third party is in the
# trust base beyond the upstream vendor itself.
{pkgs}: {
  pname,
  version,
  # Result of pkgs.fetchurl (hash-pinned) for the current platform's artifact.
  src,
  binName ? pname,
  # When the artifact is an archive (e.g. .tar.gz), set unpack = true and
  # binPath to the binary's path relative to the extracted tree.
  unpack ? false,
  binPath ? null,
  # Static environment variables to bake into the wrapper via --set.
  env ? {},
  # Tools to prepend to PATH at runtime.
  runtimeDeps ? [],
  # Extra raw makeBinaryWrapper flags; may reference $out in shell. Used for
  # values only known at install time (e.g. the unwrapped binary's store path).
  extraWrapperFlags ? "",
  # Prebuilt binaries must not be stripped (can corrupt embedded runtimes).
  dontStrip ? true,
}:
pkgs.stdenv.mkDerivation {
  inherit pname version src dontStrip;
  # Extraction (if any) is handled explicitly below, not by stdenv's
  # unpackPhase, which mishandles single-file archives.
  dontUnpack = true;

  nativeBuildInputs = [pkgs.makeBinaryWrapper];

  installPhase = let
    # Only emit --prefix PATH when there are deps; an empty makeBinPath would
    # leave --prefix without a value and swallow the next flag as its argument.
    pathFlag =
      pkgs.lib.optionalString (runtimeDeps != [])
      "--prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}";
    setEnvFlags =
      pkgs.lib.concatStringsSep " "
      (pkgs.lib.mapAttrsToList
        (k: v: "--set ${k} ${pkgs.lib.escapeShellArg (toString v)}")
        env);
    extract =
      if unpack
      then assert binPath != null; "tar -xf $src"
      else "";
    source =
      if unpack
      then binPath
      else "$src";
  in ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    ${extract}
    install -m755 ${source} $out/libexec/${binName}-unwrapped

    makeBinaryWrapper $out/libexec/${binName}-unwrapped $out/bin/${binName} \
      ${pathFlag} \
      ${setEnvFlags} \
      ${extraWrapperFlags}

    runHook postInstall
  '';

  meta.mainProgram = binName;
}
