#!/usr/bin/env bash

current_dir=$(dirname "$0")
dir=$(dirname "$current_dir")
[[ -z "$1" ]] && PROFILE_NAME=default || PROFILE_NAME="$1"
[[ -z "$DCONF" ]] && DCONF=dconf

source $dir/src/tools.sh
source $dir/src/import.sh

hex-string_to_hex-line() {
  echo "${palette//, /:}"
}

rgb-string_to_hex-line() {
  palette=$(tr -d "[:alpha:]()" <<< $palette)
  eval "palette=(${palette//, / })" # compatible array decleration for zsh and bash
  colors=()
  for color in $palette; do 
    eval "values=(${color//,/ })"
    hex_color=$(printf \#%02X%02X%02X "${values[@]}") # convert to hex
    colors+=($hex_color) 
  done
  colors_string="${colors[@]}"
  echo "${colors_string// /:}"
}

array-string_to_hex-string() {
  palette="$1"
  palette=${palette:1:${#palette}-2} # remove [...]
  if [[ "${palette:0:1}" = "r" ]]; then
    palette=$(rgb-string_to_hex-line "$palette")
  else
    palette=$(hex-string_to_hex-line "$palette")
  fi
  echo "$palette"
}

retrieve_color-theme_dconf() {

  [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW="/org/gnome/terminal/legacy/profiles:"

  if [ "$PROFILE_NAME" = default ]; then
    PROFILE_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
    PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"
    PROFILE_NAME="`$DCONF read $PROFILE_KEY/visible-name | tr -d \'`"
  else
    for PROFILE_SLUG in `$DCONF list $BASE_KEY_NEW/ | grep '^:' | tr -d :/`; do 
      PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"
      PROFILE_NAME="`$DCONF read $PROFILE_KEY/visible-name | tr -d \'`"
      if [ "`$DCONF read $PROFILE_KEY/visible-name`" = "$PROFILE_NAME" ]; then
        break
      fi
    done
  fi

  PROFILE_NAME_SLUG=${PROFILE_NAME// /-}

  palette="`$DCONF read $PROFILE_KEY/palette | tr -d \'`"
  bg_color="`$DCONF read $PROFILE_KEY/background-color | tr -d \'`"
  fg_color="`$DCONF read $PROFILE_KEY/foreground-color | tr -d \'`"
  bd_color="`$DCONF read $PROFILE_KEY/bold-color | tr -d \'`"


  if [[ "${palette:0:1}" == "[" ]]; then # rgb notation
    palette=$(array-string_to_hex-string "$palette")
  fi

  import_color_theme 
}

if [ "$newGnome" = "1" ]; then
  retrieve_color-theme_dconf $PROFILE_NAME
else
  die "gnome-terminal version too old for dconf, and gconftool method not implemented"
fi
