package TwitSave;

use AnyEvent::Twitter::Stream;
use Encode qw/encode_utf8 decode_utf8/;

sub new {
    my ($class, $dbi, $config) = @_;

    my $self = bless {}, $class;
    $self->{dbi} = $dbi;
    $self->{config} = $config;
    return $self;
}

sub on_error {
  my $self = shift;
  return sub {
    my $error = shift;
    my $msg = "exited on error: $error";
    terminate($msg);
  }
}

sub on_eof {
  my $self = shift;
  return sub {
    printf STDERR "reconnected on eof\n";
    $self->{listener} = $self->connect_twitter();
  }
}

sub terminate {
  my $msg = shift;
  printf STDERR "$msg\n";
  exit 1;
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

sub connect_twitter {
    my ($self) = @_;
    my $config = $self->{config};
    AnyEvent::Twitter::Stream->new(
        consumer_key    => $config->{consumer_key},
        consumer_secret => $config->{consumer_secret},
        token           => $config->{token},
        token_secret    => $config->{token_secret},
        method          => "sample",
        on_tweet        => \&{$self->on_tweet},
        on_error        => \&{$self->on_error},
        on_eof          => \&{$self->on_eof},
    );
}

sub listen {
    my ($self) = @_;
    my $done = AE::cv;
    $self->{listener} = $self->connect_twitter();
    $done->recv;
}

1;
