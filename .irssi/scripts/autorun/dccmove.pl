use strict;
use Irssi;
use File::Path::Expand;
use vars qw($VERSION %IRSSI);

$VERSION = 20140403;
%IRSSI = (
    authors     => "ahoka",
    contact     => "ahoka on irc.rizon.net",
    name        => "dccmove.pl",
    description => "Intelligently sets download location based on file name",
);

my $orig_down_path = Irssi::settings_get_str("dcc_download_path");

sub on_dcc_request {
    my ($dcc, $sendaddr) = @_;
    my $filename = $dcc->{arg};

    $filename =~ s/_/ /g;

    if ($filename =~ m/^(?:\[.+\]\s)?(.+)(?:\s-\s.+)$/)
    {
        my $dir = expand_filename(Irssi::settings_get_str("dccmove_dir") . "/" . $1);

        if (-d $dir)
        {
            Irssi::settings_set_str("dcc_download_path", $dir);
            print "dccmove: saving " . $dcc->{arg} . " in " . $dir;
        }
    }
}

sub on_dcc_receive {
    Irssi::settings_set_str("dcc_download_path", $orig_down_path);
}

Irssi::settings_add_str("dccmove", "dccmove_dir", $orig_down_path);
Irssi::signal_add("dcc request", "on_dcc_request");
Irssi::signal_add("dcc get receive", "on_dcc_receive");
