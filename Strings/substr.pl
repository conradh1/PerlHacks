#!/usr/local/bin/perl -- -*-perl-*-
#This is a perl program that shows the use of the substr method.
my $quote= " dog has very sharp teeth !";
substr($quote, 0, 0)= "Conrad's";
# Inserts a word at the start of the string

print "$quote\n";

substr($quote, 0, 6)= "Eugene";
# replaces 8 characters starting from position 0 in the orginal string  with a different string
substr($quote, 22,5 )= "dull";
# replaces 5 characters starting from position 22 in the orginal string  with a different string

print "$quote\n"; 

substr($quote, 0, 8)= "Daryl's";
# replaces 8 characters starting from position 0 in the orginal string  with a different string
substr($quote, 16)= "red gums.";
# replaces all characters apending position 16 in the orginal string  with a different string

print "$quote\n";
#main program
