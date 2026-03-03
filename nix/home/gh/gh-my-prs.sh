line=$(
  gh search prs --author=@me --state=open \
    --json repository,number,title \
    --template '{{range .}}{{.repository.nameWithOwner}}#{{.number}} {{.title}}{{"\n"}}{{end}}' \
  | fzf --prompt='My PRs> '
) || exit

repo="${line%%[#]*}"
num="$(printf '%s\n' "$line" | awk -F'[# ]' '{print $2}')"

if [[ -n "$repo" && -n "$num" ]]; then
  gh pr view "$num" --repo "$repo" --web
fi
