#!/bin/sh

export APPROOT=/home/kurain/apps/TwitSave
export CPANLIB=$APPROOT/shared/lib/perl5/
export PERL5LIB=$APPROOT/shared/lib/perl5/x86_64-linux/:$APPROOT/shared/lib/perl5
export PERLBASE=/home/kurain/perl5/perlbrew/perls/perl-5.14.2

exec 2>&1
exec \
  setuidgid kurain \
  LC_ALL=C $PERLBASE/bin/perl -I$APPROOT/shared/lib/perl5 -I$APPROOT/current/lib $APPROOT/current/bin/crawler.pl

