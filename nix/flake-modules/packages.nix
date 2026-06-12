# Vendored, trust-minimized CLIs exposed as flake packages so they can be
# built and verified directly (e.g. `nix build .#codex`) as part of the
# update flow. Each package.nix is self-contained; see ../packages/.
{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      claude-code = import ../packages/claude-code/package.nix {inherit pkgs;};
      codex = import ../packages/codex/package.nix {inherit pkgs;};
    };
  };
}
