line=$(
  gh search prs --author=@me --state=open \
    --json repository,number,title,createdAt,updatedAt \
    --template '{{range .}}{{.title}}{{"\t"}}{{printf "%.10s" .createdAt}}{{"\t"}}{{printf "%.10s" .updatedAt}}{{"\t"}}{{.repository.nameWithOwner}}#{{.number}}{{"\n"}}{{end}}' \
  | column -t -s $'\t' \
  | fzf --prompt='My PRs> '
) || exit

repo_num="$(grep -oE '[^[:space:]]+/[^[:space:]]+#[0-9]+' <<< "$line")"
repo="${repo_num%%#*}"
num="${repo_num##*#}"

if [[ -n "$repo" && -n "$num" ]]; then
  gh pr view "$num" --repo "$repo" --web
fi
