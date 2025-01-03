#!/usr/bin/env bash

spaces() {
    # niri msg -j workspaces | jq -Mc '.=sort_by(.id) | if .[-1].is_focused then . else .[0:-1] end'
    niri msg -j workspaces | jq -Mc '.=sort_by(.id)'
}

spaces
niri msg event-stream | while read -r line; do
    spaces
done
