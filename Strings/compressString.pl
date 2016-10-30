#!/usr/local/bin/perl -- -*-perl-*-
# compress a string using substr.
# example aaabbbc is a3b3c  use substr for this
use strict;

my $word = <STDIN>;
my $compress = '';
chop($word);


my @letters = split(//,$word);


my $i = 0;

while ( $i <= $#letters ) {
  if ( $letters[$i] eq $letters[$i+1] ) {
    $compress .= $letters[$i];
    my $c = 1;
    my $l = $letters[$i];
    while ( $i <= $#letters && $l eq $letters[++$i] ) {
      $c++;
    }
    $compress .= $c;
  }
  else {
    $compress .= $letters[$i];
    $i++;
  }
}



print "$compress\n";
exit 0;

#end of test program




