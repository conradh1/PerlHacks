#!/usr/bin/perl --
use strict;

my %hash;

my $zero= 'key3';

$hash{'key1'} = 'value1';
$hash{'key2'} = 'value2';

for (my $i= 0; $i < 6; $i++) {
  $hash { $zero } += $i;
}

$hash{'key4'} = 'value4';

for my $key ( sort keys %hash ) {
  my $value = $hash{$key};
  print "$key => $value\n";
}
