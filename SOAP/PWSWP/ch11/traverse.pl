#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

my $startURL = 'http://www.soaplite.com/oreilly/books/';

# get list of O'Reilly books
foreach my $book (parse(get($startURL))->Book) {

  # look for Programming web services with SOAP
  next unless $book->ISBN eq '0596000952';
  print $book->Title, "\n";

  # get link to Authors for the book
  my $authorsURL = absurl(href($book->Authors), $startURL);
  foreach my $author (parse(get($authorsURL))->Author) {
    print $author->Name, "\n";

    # get link to particular Author
    my $authorURL = absurl(href($author), $authorsURL);
    my $bio = parse(get($authorURL))->Bio;

    # get link to Author's bio
    my $bioURL = absurl(href($bio), $authorURL);
    print parse(get($bioURL)), "\n";
  }
}

sub href {
  return shift->attr->{'{http://www.w3.org/1999/xlink}href'};
}

sub get {
  use LWP::UserAgent;
  my $url = shift;
  my $req = HTTP::Request->new(GET => $url, HTTP::Headers->new);
  $req->header(Accept => 'text/xml');
  my $res = LWP::UserAgent->new->request($req);
  die $res->status_line unless $res->is_success;
  return $res->content;
}

sub parse {
  use SOAP::Lite;
  return SOAP::Custom::XML::Deserializer->deserialize(shift)->root;
}

sub absurl {
  use URI;
  my($url, $baseurl) = @_;
  return $url unless $baseurl;
  URI->new_abs($url, $baseurl)->as_string;
}
