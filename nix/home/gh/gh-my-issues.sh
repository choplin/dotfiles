line=$(
  gh search issues --author=@me --state=open --limit 100 \
    --json repository,number,title,createdAt,updatedAt \
    --template '{{range .}}{{.title}}{{"\t"}}{{printf "%.10s" .createdAt}}{{"\t"}}{{printf "%.10s" .updatedAt}}{{"\t"}}{{.repository.nameWithOwner}}#{{.number}}{{"\n"}}{{end}}' \
    -- archived:false \
  | column -t -s $'\t' \
  | fzf --prompt='My Issues> '
) || exit

repo_num="$(grep -oE '[^[:space:]]+/[^[:space:]]+#[0-9]+' <<< "$line")"
repo="${repo_num%%#*}"
num="${repo_num##*#}"

if [[ -n "$repo" && -n "$num" ]]; then
  gh issue view "$num" --repo "$repo" --web
fi
