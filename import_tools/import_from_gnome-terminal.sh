#!/usr/bin/env bash

dir=`dirname "$0"`
[[ -z "$1" ]] && PROFILE_NAME=default || PROFILE_NAME="$1"
[[ -z "$DCONF" ]] && DCONF=dconf

source $dir/src/tools.sh
source $dir/src/import.sh

retrieve_color-theme_dconf() {

  [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

  if [ ! "$PROFILE_NAME" = default ]; then
    PROFILE_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
    PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"
    PROFILE_NAME="`$DCONF read $PROFILE_KEY/visible-name`"
  else
    for PROFILE_SLUG in `$DCONF list $BASE_KEY_NEW/ | grep '^:' | tr -d :/`; do 
      PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"
      PROFILE_NAME="`$DCONF read $PROFILE_KEY/visible-name`"
      if [ "`$DCONF read $PROFILE_KEY/visible-name`" = $PROFILE_NAME ]; then
        break
      fi
    done
  fi

  palette="`$DCONF read $PROFILE_KEY/palette | tr -d \'`"
  bg_color="`$DCONF read $PROFILE_KEY/background-color | tr -d \'`"
  fg_color="`$DCONF read $PROFILE_KEY/foreground-color | tr -d \'`"
  bd_color="`$DCONF read $PROFILE_KEY/bold-color | tr -d \'`"

  import_color_theme 
}

if [ "$newGnome" = "1" ]; then
  retrieve_color-theme_dconf $PROFILE_NAME
else
  die "gnome-terminal version too old for dconf and gconftool method not implemented"
fi
