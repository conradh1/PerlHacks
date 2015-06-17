#!/usr/local/bin/perl -- -*-perl-*-
#This program uses the split, push and pop methods 
#to show the power of string manipulation.
use strict;

my $quote= 'Many, Commas, will, be, placed.'; 
my $new_quote;
my @word = split(/,\s/,$quote); #assign an indexes where a comma occurs

print "$quote\n"; #show original quote

pop(@word); 
#removes the last word in the arrray

push (@word, 'removed.'); 
#places the word 'removed' at the end of the array

foreach (@word)  {
    $new_quote.= $_." ";
}
print "$new_quote\n";

exit 0;

#end of test program




