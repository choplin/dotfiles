#!/usr/bin/env bash
# Refresh sources.json for claude-code.
#
# Trust base: registry.npmjs.org (latest version of @anthropic-ai/claude-code,
# Anthropic's npm) and downloads.claude.ai (Anthropic's CDN). Hashes are taken
# from the CDN's signed-by-TLS manifest.json (which lists a sha256 per
# platform), so all-arch hashes are recorded without downloading any binary.
# No third-party packaging is trusted. The per-arch checksum is still verified
# against the real binary by Nix at build time (fetchurl with this hash).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pkg="@anthropic-ai/claude-code"
base="https://downloads.claude.ai/claude-code-releases"

# Nix system → Anthropic release platform string (manifest.json key).
declare -A platforms=(
  [aarch64-darwin]=darwin-arm64
  [x86_64-darwin]=darwin-x64
  [x86_64-linux]=linux-x64
  [aarch64-linux]=linux-arm64
)

version="$(curl -fsSL "https://registry.npmjs.org/${pkg}/latest" | jq -r .version)"
echo "latest ${pkg} = ${version}" >&2

manifest="$(curl -fsSL "${base}/${version}/manifest.json")"

hashes="{}"
for sys in "${!platforms[@]}"; do
  platform="${platforms[$sys]}"
  hex="$(jq -r --arg p "$platform" '.platforms[$p].checksum // empty' <<<"$manifest")"
  [[ -n "$hex" ]] || {
    echo "no checksum for ${platform} in manifest" >&2
    exit 1
  }
  sri="$(nix hash convert --hash-algo sha256 --to sri "$hex")"
  hashes="$(jq --arg s "$sys" --arg h "$sri" '. + {($s): $h}' <<<"$hashes")"
done

jq -n --arg v "$version" --argjson h "$hashes" '{version: $v, hashes: $h}' \
  >"${here}/sources.json"
echo "wrote ${here}/sources.json" >&2
