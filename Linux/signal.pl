#!/usr/local/bin/perl -- -*-perl-*-
use strict;
use warnings;

print "Countdown: ";

$SIG{INT} = sub { die "Caught a sigint $!" };
$SIG{TERM} = sub { die "Caught a sigterm $!" };

for ( my $i = 10; $i >= 0; $i--) {
 print "$i ";
 sleep 1;
}
print "\n";
