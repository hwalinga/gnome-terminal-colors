#!/usr/bin/env bash

current_dir=$(dirname "$0")
dir=$(dirname "$current_dir")
[[ -z "$GCONFTOOL" ]] && GCONFTOOL=gconftool-2
[[ -z "$BASE_KEY" ]] && BASE_KEY=/apps/guake/style
schemes=($(cd $dir/colors && echo * && cd - > /dev/null))

gset() {
    local type="$1"; shift
    local key="$1"; shift
    local val="$1"; shift

    "$GCONFTOOL" --set --type "$type" "$BASE_KEY/$key" -- "$val"
}

create_hex_repetition() { # { #2e3436 -> #2e2e34343636 } I also don't know why Guake saves colors as such
  if [[ ${#1} -ge 13 ]]; then
    echo $1
  else
    echo "#${1:1:2}${1:1:2}${1:3:2}${1:3:2}${1:5:2}${1:5:2}"
  fi
}

create_hex_repetition_palette() {
  inp=($(echo $1))
  colors=()
  for color in ${inp[@]}; do
    colors+=($(create_hex_repetition $color))
  done
  colors_string="${colors[@]}"
  echo "${colors_string// /:}"
}

interactive_select_scheme() {
  echo "Please select a color scheme:"
  select scheme
  do
    if [[ -z $scheme ]]
    then
      echo "ERROR: Wrong input; aborting."
      exit 1
    fi
    break
  done
  echo
}

interactive_select_scheme "${schemes[@]}"

source="$dir/colors/$scheme"

gset string "font/palette_name" Custom
gset string "font/palette" "$(create_hex_repetition_palette "$(< "$source/palette")")"
gset string "background/color" "$(create_hex_repetition "$(< "$source/bg_color")")"
gset string "font/color" "$(create_hex_repetition "$(< "$source/fg_color")")"

