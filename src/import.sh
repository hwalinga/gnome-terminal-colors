#!/usr/bin/env bash

import_color_theme() {
  while [ -d "$dir/colors/$PROFILE_NAME_SLUG" ]; do
    echo "$PROFILE_NAME_SLUG already exists."
    echo "Do you want to override?"
    echo -n "(y to continue, or type alternative) "
    read confirmation
    if [[ $confirmation = y ]]; then
      rm "$dir/colors/$PROFILE_NAME_SLUG/*"
      break
    fi
    while [[ $PROFILE_NAME_SLUG = "" || $PROFILE_NAME_SLUG = *[$' \t\n']* ]]; do 
      echo "$PROFILE_NAME_SLUG cannot contain whitespace, or be an empty string."
      echo -n "Provide an alternative: "
      read PROFILE_NAME_SLUG
    done
  done
  target="$dir/colors/$PROFILE_NAME_SLUG"
  mkdir -p "$target"
  
  echo -e ${palette//:/\\n} > $target/palette
  echo $bg_color > $target/bg_color
  echo $fg_color > $target/fg_color
  echo $bd_color > $target/bd_color
  
}

