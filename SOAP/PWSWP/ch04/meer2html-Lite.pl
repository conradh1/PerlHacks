#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;
use vars qw($chan $cat $num $data $client);

use XMLRPC::Lite;
use constant MEERKAT =>
    'http://www.oreillynet.com/meerkat/xml-rpc/server.php';

# Read and test the command-line arguments.
if ($ARGV[0] =~ /^-ch/) {
    $chan = $ARGV[1];
    $num  = $ARGV[2] || 15;
} elsif ($ARGV[0] =~ /^-ca/) {
    $cat = $ARGV[1];
    $num = $ARGV[2] || 15;
}
unless (($chan or $cat) and ($num =~ /^\d+$/)) {
    die "USAGE: $0 { -channel str | -category str } [ n ]";
}

# Creating a client object happens automatically when one of
# the methods such as proxy() is called. The on_fault call
# sets up a handler call-back for transport errors.
$client = XMLRPC::Lite->proxy(MEERKAT)
          ->on_fault(sub { die "Transport error: " .
                               $_[1]->faultstring });

# This could be done with just one data-retrieval routine,
# but this way is easier to follow, and tests $chan/$cat
# less-often.
$data = $chan ? data_from_chan($chan, $num) :
                data_from_cat($cat, $num);
show_data($data);

exit;

# Retrieve data from a 'Channel' source
sub data_from_chan {
    my ($chan, $num) = @_;

    # If $chan is not already numeric, convert it by using
    # an intermediate XML-RPC call
    $chan = resolve_name($chan, 'Channels')
        unless ($chan =~ /^\d+$/);
    get_data(channel => $chan, $num);
}

# Retrieve data from a 'Category' source
sub data_from_cat {
    my ($cat, $num) = @_;

    # If $cat is not already numeric, convert it by using
    # an intermediate XML-RPC call
    $cat = resolve_name($cat, 'Categories')
        unless ($cat =~ /^\d+$/);
    get_data(category => $cat, $num);
}

# Output the HTML fragment for the data. Note that the way
# the data is treated is independant of whether the source
# was a category or a channel
sub show_data {
    my $data = shift;

    print STDOUT qq(<span class="meerkat">\n<dl>\n);
    for (@$data) {
        print STDOUT <<"END_HTML";
<dt class="title"><a href="$_->{link}">$_->{title}</a></dt>
<dd class="description">$_->{description}</dd>
END_HTML
    }
    print STDOUT qq(</dl>\n</span>\n);
}

# Resolve a substring name-fragment into the numeric ID that
# the call later on in get_data requires
sub resolve_name {
    my ($str, $name) = @_;

    # Fortunately, the calling syntax is the same for
    # categories or channels, the only difference being
    # the name of the remote procedure
    $name = "meerkat.get${name}BySubstring";
    my $resp = $client->call($name, $str)->result;
    # We aren't doing multi-channels (yet), so report an
    # error if the substring returns more than one hit
    die "resolve_name: $str returned more than 1 match"
        if (@$resp > 1);

    $resp->[0]{id};
}

# Get the data-- the result of the method call below happens
# to return the data in the exact format needed by show_data
sub get_data {
    my ($key, $val, $num) = @_;

    $client->call('meerkat.getItems',
                  { $key         => $val,
                    time_period  => '7DAY',
                    num_items    => $num,
                    descriptions => 200 })->result;
}
