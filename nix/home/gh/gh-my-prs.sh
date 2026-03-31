line=$(
  gh search prs --author=@me --state=open --limit 100 \
    --json repository,number,title,createdAt,updatedAt,isDraft \
    --template '{{range .}}{{if .isDraft}}[DRAFT] {{end}}{{.title}}{{"\t"}}{{printf "%.10s" .createdAt}}{{"\t"}}{{printf "%.10s" .updatedAt}}{{"\t"}}{{.repository.nameWithOwner}}#{{.number}}{{"\n"}}{{end}}' \
    -- archived:false \
  | column -t -s $'\t' \
  | fzf --prompt='My PRs> '
) || exit

repo_num="$(grep -oE '[^[:space:]]+/[^[:space:]]+#[0-9]+' <<< "$line")"
repo="${repo_num%%#*}"
num="${repo_num##*#}"

if [[ -n "$repo" && -n "$num" ]]; then
  gh pr view "$num" --repo "$repo" --web
fi
