line=$(
  gh status 2>/dev/null \
  | awk '
    /^Review Requests/ { flag=1; next }
    /^Repository Activity/ { flag=0 }
    flag && /^[[:space:]]*$/ { next }
    flag && /[^[:space:]\/]+\/[^[:space:]]+#[0-9]+/ {
      if (line) print line
      line = $0
      next
    }
    flag { sub(/^[[:space:]]+/, ""); line = line " " $0 }
    END { if (line) print line }
  ' \
  | fzf --prompt='Review Requests> '
) || exit

repo="${line%%[#]*}"
repo="${repo%"${repo##*[![:space:]]}"}"
num="$(printf '%s\n' "$line" | awk -F'[# ]' '{print $2}')"

if [[ -n "$repo" && -n "$num" ]]; then
  gh pr view "$num" --repo "$repo" --web
fi
