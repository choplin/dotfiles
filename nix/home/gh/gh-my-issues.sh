header_enter="Print local path"
if [[ "${1:-}" == "--cd" ]]; then
  header_enter="cd to local path"
fi

result=$(
  gh search issues --author=@me --state=open --limit 100 \
    --json repository,number,title,createdAt,updatedAt \
    --template '{{range .}}{{.title}}{{"\t"}}{{printf "%.10s" .createdAt}}{{"\t"}}{{printf "%.10s" .updatedAt}}{{"\t"}}{{.repository.nameWithOwner}}#{{.number}}{{"\n"}}{{end}}' \
    -- archived:false \
  | column -t -s $'\t' \
  | fzf --prompt='My Issues> ' \
      --header "Enter: ${header_enter}, Ctrl-O: Open in browser" \
      --bind 'enter:accept' \
      --bind 'ctrl-o:print(__web)+accept'
) || exit

line="$result"
if [[ $result == __web* ]]; then
  line="${result#*$'\n'}"
fi

repo_num="$(grep -oE '[^[:space:]]+/[^[:space:]]+#[0-9]+' <<< "$line")"
repo="${repo_num%%#*}"
num="${repo_num##*#}"

if [[ -z "$repo" || -z "$num" ]]; then
  exit
fi

if [[ $result != __web* ]]; then
  ghq_root="$(ghq root)"
  repo_path="${ghq_root}/github.com/${repo}"
  if [[ ! -d "$repo_path" ]]; then
    echo "Error: Repository not found locally: ${repo}" >&2
    exit 1
  fi

  echo "$repo_path"
else
  gh issue view "$num" --repo "$repo" --web
fi
