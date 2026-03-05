line=$(
  gh search prs \
    --review-requested=@me \
    --state=open \
    --json repository,number,title,createdAt,updatedAt,author \
    --template '{{range .}}{{.title}}{{"\t"}}{{.author.login}}{{"\t"}}{{printf "%.10s" .createdAt}}{{"\t"}}{{printf "%.10s" .updatedAt}}{{"\t"}}{{.repository.nameWithOwner}}#{{.number}}{{"\n"}}{{end}}' \
  | column -t -s $'\t' \
  | fzf --prompt='Review Requests> '
) || exit

repo_num="$(grep -oE '[^[:space:]]+/[^[:space:]]+#[0-9]+' <<< "$line")"
repo="${repo_num%%#*}"
num="${repo_num##*#}"

if [[ -n "$repo" && -n "$num" ]]; then
  gh pr view "$num" --repo "$repo" --web
fi
