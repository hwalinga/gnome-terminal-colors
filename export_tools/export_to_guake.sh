#!/usr/bin/env bash

dir=`dirname $0`
color_scheme="$1"
[[ -z "$GCONFTOOL" ]] && GCONFTOOL=gconftool-2
[[ -z "$BASE_KEY" ]] && BASE_KEY=/apps/guake/style

gset() {
    local type="$1"; shift
    local key="$1"; shift
    local val="$1"; shift

    "$GCONFTOOL" --set --type "$type" "$BASE_KEY/$key" -- "$val"
}

create_hex_repetition() { # { #2e3436 -> #2e2e34343636 } I also don't know why Guake saves colors as such
  echo "#${1:1:2}${1:1:2}${1:3:2}${1:3:2}${1:5:2}${1:5:2}"
}

create_hex_repetition_palette() {
  colors=()
  for color in $1; do
    colors+=('$(create_hex_repetition $color)')
  done
  colors_string="${colors[@]}"
  echo "${colors// /:}"
}

source="$dir/colors/$color_scheme"
if [ ! -d $source ]; then
  echo "$color_scheme does not exist"
  exit 1
fi

gset string "font/palette_name" Custom
gset string "font/palette" "$(create_hex_repetition_palette $(cat "$source/palette"))"
gset string "background/color" "$(create_hex_repetition $(cat "$source/bg_color"))"
