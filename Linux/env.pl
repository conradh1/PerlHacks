#!/usr/local/bin/perl -- -*-perl-*-
use Env;

# prints user environment
for my $key ( sort keys %ENV ) {
  my $value = $ENV{$key};
  print "$key => $value\n";
}



