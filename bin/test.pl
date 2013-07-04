package TwitSave;

use AnyEvent::Twitter::Stream;
use Encode qw/encode_utf8 decode_utf8/;
use Config::Pit;

my $config = Config::Pit::get('twitter.com');
my $done = AE::cv;
my $listener = AnyEvent::Twitter::Stream->new(
    consumer_key    => $config->{consumer_key},
    consumer_secret => $config->{consumer_secret},
    token           => $config->{token},
    token_secret    => $config->{token_secret},
    method          => "sample",
    on_tweet        => sub {
        my ($tweet) = @_;
        if ($tweet->{lang} eq 'ja') {
            warn $tweet->{text};
        }
    },
);

$self->{listener} = $listener;
$done->recv;

