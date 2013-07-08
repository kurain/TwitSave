use warnings;
use strict;

use FindBin::libs;
use TwitSave;

use Config::Pit;
use DBI;

my $config = Config::Pit::get('twitter.com');
my $dbi    = DBI->connect_cached(
    'DBI:mysql:database=tweets;', 'nobody', 'nobody',
    {
        mysql_enable_utf8 => 1,
        on_connect_do => ['SET NAMES utf8'],
    }
);
my $saver = TwitSave->new($dbi, $config);
$saver->listen();

1;
