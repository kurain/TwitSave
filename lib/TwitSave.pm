package TwitSave;

use AnyEvent::Twitter::Stream;
use Encode qw/encode_utf8 decode_utf8/;

sub new {
    my ($class, $dbi) = @_;

    my $self = bless {}, $class;
    $self->{dbi} = $dbi;
    return $self;
}

sub on_tweet {
    my $self = shift;
    return sub {
        my ($tweet) = @_;
        if ($tweet->{lang} eq 'ja') {
            $self->{dbi}->do(
                q{INSERT INTO tweets (id, text) VALUES (?, ?)},
                undef,
                ($tweet->{id}, $tweet->{text}),
            );
        }
    }
}

sub listen {
    my ($self, $config) = @_;

    my $done = AE::cv;
    my $listener = AnyEvent::Twitter::Stream->new(
        consumer_key    => $config->{consumer_key},
        consumer_secret => $config->{consumer_secret},
        token           => $config->{token},
        token_secret    => $config->{token_secret},
        method          => "sample",
        on_tweet        => \&{$self->on_tweet},
    );
    $self->{listener} = $listener;
    $done->recv;
}

1;
