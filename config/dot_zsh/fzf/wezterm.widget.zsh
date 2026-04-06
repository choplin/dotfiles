function __fzf_wezterm_pane() {
    local panes
    panes=$(wezterm cli list --format json 2>/dev/null)

    if [[ -z "$panes" || "$panes" == "[]" ]]; then
        echo "\033[31mError: No WezTerm panes found\033[0m"
        zle send-break
        return 1
    fi

    # Get the window_id of the current pane
    local window_id
    window_id=$(echo "$panes" | jq -r --arg pid "$WEZTERM_PANE" \
        '.[] | select(.pane_id == ($pid | tonumber)) | .window_id')

    local result
    result=$(echo "$panes" | jq -r --arg wid "$window_id" --arg pid "$WEZTERM_PANE" \
        '[.[] | select(.window_id == ($wid | tonumber))] | .[] |
        "\(.pane_id)|\(.tab_id)|\(if .pane_id == ($pid | tonumber) then true else false end)|\(.title)|\(.cwd | sub("file://[^/]*"; ""))"' | \
        # Format columns with Unicode-aware padding (handles CJK/emoji width)
        # Input: pane_id|tab_id|is_current|title|cwd
        # Output: pane_id\t<formatted columns>
        python3 -c '
import sys, re, unicodedata

def display_width(s):
    """Calculate terminal display width accounting for wide characters."""
    return sum(2 if unicodedata.east_asian_width(c) in ("F","W") else 1 for c in s)

def fit(s, w):
    """Truncate string to w display-columns and pad with spaces."""
    r, d = [], 0
    for c in s:
        cw = 2 if unicodedata.east_asian_width(c) in ("F","W") else 1
        if d + cw > w: break
        r.append(c); d += cw
    return "".join(r) + " " * (w - d)

# First pass: collect lines and build tab_id -> index mapping
lines = [l.rstrip("\n") for l in sys.stdin]
tab_ids = dict()  # tab_id -> index (ordered by first appearance)
for l in lines:
    tid = l.split("|")[1]
    if tid not in tab_ids:
        tab_ids[tid] = len(tab_ids)

for l in lines:
    f = l.split("|")
    active = "*" if f[2] == "true" else " "
    cwd = re.sub(r"/Users/[^/]+", "~", f[4])
    tab_idx = tab_ids[f[1]]
    print(f"{f[0]}\t{active} {tab_idx:<4} {f[0]:<6} {fit(f[3], 30)} {cwd}")
' | \
        fzf --height=100% --layout=reverse --info=inline --delimiter='\t' \
            --header="  Tab  Pane   Title                           CWD" \
            --with-nth=2.. \
            --preview='wezterm cli get-text --pane-id {1}' \
            --preview-window="bottom:70%:follow"
    )

    if [[ -n "$result" ]]; then
        local pane_id
        pane_id=$(echo "$result" | cut -f1)
        wezterm cli activate-pane --pane-id "$pane_id"
    fi
    zle reset-prompt
}

wk-register "Ctrl-O Ctrl-P" "WezTerm: Pane Selector" __fzf_wezterm_pane

function __fzf_wezterm_tab() {
    local panes
    panes=$(wezterm cli list --format json 2>/dev/null)

    if [[ -z "$panes" || "$panes" == "[]" ]]; then
        echo "\033[31mError: No WezTerm panes found\033[0m"
        zle send-break
        return 1
    fi

    # Get the window_id of the current pane
    local window_id
    window_id=$(echo "$panes" | jq -r --arg pid "$WEZTERM_PANE" \
        '.[] | select(.pane_id == ($pid | tonumber)) | .window_id')

    # Group by tab: show active pane info per tab, count panes
    local result
    result=$(echo "$panes" | jq -r --arg wid "$window_id" --arg pid "$WEZTERM_PANE" '
        [.[] | select(.window_id == ($wid | tonumber))] |
        group_by(.tab_id) | .[] |
        {
            tab_id: .[0].tab_id,
            pane_count: length,
            active_pane: (map(select(.is_active)) | .[0] // .[0]),
            has_current_pane: (map(.pane_id) | any(. == ($pid | tonumber)))
        } |
        "\(.tab_id)|\(.active_pane.pane_id)|\(.has_current_pane)|\(.active_pane.title)|\(.active_pane.cwd | sub("file://[^/]*"; ""))|\(.pane_count)"
    ' | \
        # Format columns with Unicode-aware padding (handles CJK/emoji width)
        # Input: tab_id|active_pane_id|has_current|title|cwd|pane_count
        # Output: tab_id\tpane_id\t<formatted columns>
        python3 -c '
import sys, re, unicodedata

def display_width(s):
    """Calculate terminal display width accounting for wide characters."""
    return sum(2 if unicodedata.east_asian_width(c) in ("F","W") else 1 for c in s)

def fit(s, w):
    """Truncate string to w display-columns and pad with spaces."""
    r, d = [], 0
    for c in s:
        cw = 2 if unicodedata.east_asian_width(c) in ("F","W") else 1
        if d + cw > w: break
        r.append(c); d += cw
    return "".join(r) + " " * (w - d)

idx = 0
for line in sys.stdin:
    f = line.rstrip("\n").split("|")
    active = "*" if f[2] == "true" else " "
    cwd = re.sub(r"/Users/[^/]+", "~", f[4])
    print(f"{f[0]}\t{f[1]}\t{active} {idx:<6} {fit(f[3], 30)} {f[5]:<6} {cwd}")
    idx += 1
' | \
        fzf --height=100% --layout=reverse --info=inline --delimiter='\t' \
            --header="  Index  Title                           Panes  CWD" \
            --with-nth=3.. \
            --preview='wezterm cli get-text --pane-id {2}' \
            --preview-window="bottom:70%:follow"
    )

    if [[ -n "$result" ]]; then
        local tab_id
        tab_id=$(echo "$result" | cut -f1)
        wezterm cli activate-tab --tab-id "$tab_id"
    fi
    zle reset-prompt
}

wk-register "Ctrl-O Ctrl-T" "WezTerm: Tab Selector" __fzf_wezterm_tab
