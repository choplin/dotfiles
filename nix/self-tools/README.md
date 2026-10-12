# Self-authored tools

This directory keeps the installation of self-authored CLI packages separate
from the rest of the dotfiles configuration. Each tool repository owns its Nix
package definition.

Flake input declarations must remain in the top-level `flake.nix`, while package
selection and installation are kept here. To add a tool:

1. Make the tool repository expose `packages.<system>.default`.
2. Add its flake input under the self-authored tools section in `flake.nix`.
3. Expose that default package from `default.nix`.

Every package exposed by `default.nix` is installed by Home Manager. Its
attribute name must match the corresponding flake input so the devshell can
derive the update list automatically. Update only these tools with:

```sh
update-tools
```
