#!/usr/bin/perl --
use strict;

my %hash;

my @list= ( 'key1', 'key2', 'key3', 'key2', 'key2' );

foreach (@list) {
  $hash{ $_ } .= "hello ";
}

for my $key ( sort keys %hash ) {
  my $value = $hash{$key};
  print "$key => $value\n";
}
print $hash { 'key1'};
my $key3 = 'key3';
print $hash { $key3 };
