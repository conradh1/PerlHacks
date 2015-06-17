#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

use SOAP::Lite;
use XML::RSS;

my $user = shift ||
    die "Usage: $0 userID [ usernick ]\n\nStopped";
my $nick = shift || "#$user";

my $host        = 'use.perl.org';
my $uri         = "http://$host/Slash/Journal/SOAP";
my $proxy       = "http://$host/journal.pl";

my $journal = SOAP::Lite->uri($uri)->proxy($proxy);
my $results = $journal->get_entries($user, 15)->result;
my $rss     = XML::RSS->new(version => '1.0');

$rss->channel(title       => "use.perl.org journal of $nick",
              'link'      => $proxy,
              description => "The use.perl.org journal of $nick");
$rss->add_item(title  => $_->{subject}, 'link' => $_->{url})
    for (@$results);

print STDOUT $rss->as_string;
exit;
