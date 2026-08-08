{pkgs, ...}: let
  version = "0.3.2";

  pen-cli = pkgs.buildNpmPackage {
    pname = "pen-cli";
    inherit version;
    src = ./.;

    npmDepsHash = "sha256-2uIy86sOsehStlSO7709USjd5vKk2uuFBAi/i7KmpjE=";
    dontNpmBuild = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/pen-cli $out/bin
      cp -r node_modules $out/lib/pen-cli/node_modules
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/pen \
        --add-flags $out/lib/pen-cli/node_modules/@pen.dev/cli/dist/index.mjs
      ln -s pen $out/bin/pencil
      runHook postInstall
    '';

    meta = {
      description = "CLI for creating and editing .pen design files";
      homepage = "https://docs.pen.dev/for-developers/pen-cli";
      license = pkgs.lib.licenses.unfree;
      mainProgram = "pen";
    };
  };

  pen-new = pkgs.writeShellApplication {
    name = "pen-new";
    runtimeInputs = [pkgs.coreutils]
      ++ pkgs.lib.optionals pkgs.stdenv.isLinux [pkgs.xdg-utils];
    text = ''
      open_after_create=false
      target=

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --open|-o)
            open_after_create=true
            ;;
          --)
            shift
            if [[ $# -ne 1 || -n "$target" ]]; then
              echo "Usage: pen-new [--open|-o] <path>" >&2
              exit 2
            fi
            target=$1
            break
            ;;
          -*)
            echo "pen-new: unknown option: $1" >&2
            echo "Usage: pen-new [--open|-o] <path>" >&2
            exit 2
            ;;
          *)
            if [[ -n "$target" ]]; then
              echo "Usage: pen-new [--open|-o] <path>" >&2
              exit 2
            fi
            target=$1
            ;;
        esac
        shift
      done

      if [[ -z "$target" ]]; then
        echo "Usage: pen-new [--open|-o] <path>" >&2
        exit 2
      fi

      if [[ -e "$target" ]]; then
        echo "pen-new: file already exists: $target" >&2
        exit 1
      fi

      mkdir -p "$(dirname -- "$target")"
      printf '%s\n' '{"version":"2.14","children":[]}' > "$target"
      echo "Created .pen file: $target"

      if [[ "$open_after_create" == true ]]; then
        ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$target"
      fi
    '';
  };
in {
  home.packages = [
    pen-cli
    pen-new
  ];
}
