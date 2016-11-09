#!/usr/bin/env perl
#
# generates a password
#

use strict;
use warnings;

print "Enter number of characters for your passwords (8 - 25): ";


my $n = <STDIN>;
my $password = "";

die "bad number!" unless ( $n >= 8 && $n <= 25);

for ( my $i = 0; $i < $n; $i++ ) {
  my $r = int rand(126);

  if ( $r < 32 ) { $r += 32; } # make sure range is between 32 and 126
  $password .= chr($r);
}

print "Password: $password\n";


