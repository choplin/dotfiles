{
  homeDirectory,
  lib,
  pkgs,
  ...
}: let
  cargoTargetCleanup = pkgs.writeShellApplication {
    name = "cargo-target-cleanup";
    runtimeInputs = with pkgs; [coreutils findutils];
    text = ''
      set -euo pipefail

      max_age_days="''${CARGO_TARGET_MAX_AGE_DAYS:-30}"
      dry_run=false

      if [[ "''${1:-}" == "--dry-run" ]]; then
        dry_run=true
        shift
      fi

      if (( $# != 0 )); then
        echo "Usage: cargo-target-cleanup [--dry-run]" >&2
        exit 2
      fi

      if [[ ! "$max_age_days" =~ ^[0-9]+$ ]] || (( max_age_days < 1 )); then
        echo "CARGO_TARGET_MAX_AGE_DAYS must be a positive integer" >&2
        exit 2
      fi

      roots=(
        "${homeDirectory}/private-workspace"
        "${homeDirectory}/ghq"
      )
      removed=0
      retained=0

      for root in "''${roots[@]}"; do
        [[ -d "$root" ]] || continue

        while IFS= read -r -d "" target_dir; do
          # Only remove directories that carry Cargo's generated-cache markers.
          if [[ ! -f "$target_dir/CACHEDIR.TAG" && ! -f "$target_dir/.rustc_info.json" ]]; then
            continue
          fi

          recent_file="$(find "$target_dir" -type f -mtime "-$max_age_days" -print -quit)"
          if [[ -n "$recent_file" ]]; then
            ((retained += 1))
            continue
          fi

          if $dry_run; then
            echo "Would remove stale Cargo target: $target_dir"
          else
            echo "Removing stale Cargo target: $target_dir"
            rm -rf -- "$target_dir"
          fi
          ((removed += 1))
        done < <(find "$root" -type d -name target -prune -print0)
      done

      echo "Cargo target cleanup complete: selected=$removed retained=$retained max_age_days=$max_age_days dry_run=$dry_run"
    '';
  };
in {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [cargoTargetCleanup];
  };
}
