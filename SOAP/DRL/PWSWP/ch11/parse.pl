#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;
use XML::Parser;

sub parse {
  XML::Parser->new(
    Namespaces => 1, Handlers => {Start => \&start},
  )->parse(shift);
}

sub start {
  my($xp, $el) = (shift, shift);

  while (@_) {
    my($nm, $v) = (shift, shift);
    my $ns = $xp->namespace($nm) || '';
    print $el, " => ", $v, "\n"
    if $nm eq 'href' &&
       $ns eq 'http://www.w3.org/1999/xlink';
  }
}

use LWP::Simple;

parse(get('http://www.soaplite.com/oreilly/books/progwebsoap/'));
