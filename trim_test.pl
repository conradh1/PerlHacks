#!/usr/bin/perl -w
use strict;

my $str= "  Space leading and tailing  ";
my $lead= $str;
my $tail= $str;

$lead=~ s/^\s*//gi;
$tail=~ s/\s*$//gi;

print("########Orginal string below ##########\n");
print("\|$str\|\n");
print("########Without Leading Spaces ##########\n");
print("\|$lead\|\n");
print("########Without Trailing Spaces #########\n");
print("\|$tail\|\n");

exit 0;
