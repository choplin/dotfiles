#!/usr/bin/env bash
# Refresh sources.json for codex (OpenAI Codex CLI).
#
# Trust base: github.com/openai/codex release assets only. The latest stable
# `rust-v*` release is resolved via the GitHub API, and each asset's sha256 is
# read from the API's per-asset `digest` field, so all-arch hashes are recorded
# without downloading any tarball. No third-party packaging is trusted; Nix
# still verifies the checksum against the real tarball at build time.
# Set GITHUB_TOKEN to avoid the unauthenticated API rate limit.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="openai/codex"

# Nix system → Rust target triple used in the release asset name.
declare -A triples=(
  [aarch64-darwin]=aarch64-apple-darwin
  [x86_64-darwin]=x86_64-apple-darwin
  [x86_64-linux]=x86_64-unknown-linux-musl
  [aarch64-linux]=aarch64-unknown-linux-musl
)

auth=()
[[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")

# Latest stable release whose tag is a rust-v* release, with its asset list.
release="$(curl -fsSL "${auth[@]}" \
  "https://api.github.com/repos/${repo}/releases?per_page=50" \
  | jq -c '[.[] | select(.prerelease == false) | select(.tag_name | startswith("rust-v"))][0]')"
tag="$(jq -r '.tag_name // empty' <<<"$release")"
[[ "$tag" == rust-v* ]] || {
  echo "could not resolve a rust-v* release tag (got: ${tag:-null})" >&2
  exit 1
}
version="${tag#rust-v}"
echo "latest ${repo} = ${version} (${tag})" >&2

hashes="{}"
for sys in "${!triples[@]}"; do
  triple="${triples[$sys]}"
  asset="codex-${triple}.tar.gz"
  digest="$(jq -r --arg a "$asset" \
    '.assets[] | select(.name == $a) | .digest // empty' <<<"$release")"
  [[ "$digest" == sha256:* ]] || {
    echo "no sha256 digest for ${asset} (got: ${digest:-null})" >&2
    exit 1
  }
  sri="$(nix hash convert --hash-algo sha256 --to sri "${digest#sha256:}")"
  hashes="$(jq --arg s "$sys" --arg h "$sri" '. + {($s): $h}' <<<"$hashes")"
done

jq -n --arg v "$version" --argjson h "$hashes" '{version: $v, hashes: $h}' \
  >"${here}/sources.json"
echo "wrote ${here}/sources.json" >&2
