#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

use SOAP::Lite;
use XML::RSS;

my $user = shift ||
    die "Usage: $0 userID [ usernick ]\n\nStopped";
#my $nick = shift || "#$user";
my $nick;

my $host        = 'use.perl.org';
my $uri         = "http://$host/Slash/Journal/SOAP";
my $proxy       = "http://$host/journal.pl";

my $journal = SOAP::Lite->uri($uri)->proxy($proxy);
my $results = $journal->get_entries($user, 15)->result;
my @results = map {
                  my $entry = $journal->get_entry($_->{id})
                                      ->result;
                  # Imaging this uses HTML::Parser to extract
                  # roughly the first paragraph
                  my $desc = extract_desc($entry->{body});
                  # Imagine $nick wasn't set earlier
                  $nick ||= $entry->{nickname};
                  # Each map value is a small hash-reference
                  { 'link'      => $entry->{url},
                    description => $desc,
                    title       => $entry->{subject} };
              } (@$results);

my $rss     = XML::RSS->new(version => '1.0');

$rss->channel(title       => "use.perl.org journal of $nick",
              'link'      => $proxy,
              description => "The use.perl.org journal of $nick");
$rss->add_item(%$_) for (@results);

print STDOUT $rss->as_string;

exit;

sub extract_desc
{
    # This isn't doing anything fancy with HTML::Parser, but you could!
    my $text = $_[0];

    $text =~ s|</?.*?>||g;
    $text = substr($text, 0, 500);
    $text =~ s/</&lt;/g;
    $text =~ s/&/&amp;/g;

    $text;
}
