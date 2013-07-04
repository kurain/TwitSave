#!/bin/sh
APP_HOME=/home/kurain/apps/TwitSave/releases
exec 2>&1
exec \
  setuidgid kurain \
  env - PATH="$APP_HOME:$PATH" \
  LC_ALL=C perl $APP_HOME/bin/crawler.pl

