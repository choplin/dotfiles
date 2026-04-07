header_enter="Print local path"
if [[ "${1:-}" == "--widget" ]]; then
  header_enter="cd to local path"
fi

result=$(
  gh search prs --author=@me --state=open --limit 100 \
    --json repository,number,title,createdAt,updatedAt,isDraft \
    --template '{{range .}}{{if .isDraft}}[DRAFT] {{end}}{{.title}}{{"\t"}}{{printf "%.10s" .createdAt}}{{"\t"}}{{printf "%.10s" .updatedAt}}{{"\t"}}{{.repository.nameWithOwner}}#{{.number}}{{"\n"}}{{end}}' \
    -- archived:false \
  | column -t -s $'\t' \
  | fzf --prompt='My PRs> ' \
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

if [[ $result == __web* ]]; then
  if [[ "${1:-}" == "--widget" ]]; then
    echo "__web:$(gh pr view "$num" --repo "$repo" --json url -q .url)"
  else
    gh pr view "$num" --repo "$repo" --web
  fi
  exit
fi

ghq_root="$(ghq root)"
repo_path="${ghq_root}/github.com/${repo}"
if [[ ! -d "$repo_path" ]]; then
  echo "Error: Repository not found locally: ${repo}" >&2
  exit 1
fi

branch="$(gh pr view "$num" --repo "$repo" --json headRefName -q .headRefName 2>/dev/null)"

target_path="$repo_path"
if [[ -n "$branch" ]]; then
  wt_path="$(git -C "$repo_path" worktree list --porcelain 2>/dev/null \
    | awk -v branch="refs/heads/$branch" '
        /^worktree / { path = substr($0, 10) }
        /^branch / && $2 == branch { print path; exit }
      ')"
  if [[ -n "$wt_path" ]]; then
    target_path="$wt_path"
  fi
fi

echo "$target_path"
