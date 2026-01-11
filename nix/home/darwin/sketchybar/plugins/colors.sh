#!/bin/bash

# === Dracula Palette ===
# https://draculatheme.com

# Background colors
export BG="0xff282a36"
export BG_CURRENT="0xff44475a"    # Current line
export BG_SELECTION="0xff44475a"

# Foreground colors
export FG="0xfff8f8f2"
export COMMENT="0xff6272a4"       # Blue-gray, good for backgrounds

# Accent colors
export CYAN="0xff8be9fd"
export GREEN="0xff50fa7b"
export ORANGE="0xffffb86c"
export PINK="0xffff79c6"
export PURPLE="0xffbd93f9"
export RED="0xffff5555"
export YELLOW="0xfff1fa8c"

# === Semantic aliases ===
export COLOR_BAR="$BG"
export COLOR_TEXT="$FG"
export COLOR_TEXT_DIM="$COMMENT"
export COLOR_ACCENT="$PURPLE"

# Load-based colors
export COLOR_LOW="$GREEN"
export COLOR_MEDIUM="$YELLOW"
export COLOR_HIGH="$RED"

# Segment backgrounds
export COLOR_BG_PRIMARY="$COMMENT"      # Blue-gray background
export COLOR_BG_SECONDARY="$BG_CURRENT"
