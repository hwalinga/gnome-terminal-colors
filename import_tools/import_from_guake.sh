#!/usr/bin/env bash

[[ -z "$GCONFTOOL" ]] && GCONFTOOL=gconftool-2
[[ -z "$BASE_KEY" ]] && BASE_KEY=/apps/guake/style

source $dir/src/import.sh

gget() {
  $GCONFTOOL --get $BASE_KEY/$1  
}

remove_hex_repetition() { # { #2e2e34343636 -> #2e3436 } I also don't know why Guake saves colors as such
  echo "#${1:1:2}${1:5:2}${1:9:2}"
}

remove_hex_repetition_palette() {
  colors=()
  for color in ${1//:/ }; do 
    colors+=('$(remove_hex_repetition $color)')
  done
  colors_string="${colors[@]}"
  echo "${colors_string// /:}"
}
    
PROFILE_NAME_SLUG=$(gget "font/palette_name")
palette=$(remove_hex_repetition_palette $(gget "font/palette"))
bg_color=$(gget "background/color")
fg_color=$(gget "font/color")
bd_color=$fg_color

import_color_theme
