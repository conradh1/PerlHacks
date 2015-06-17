#!/usr/local/bin/perl -- -*-perl-*-
##This is a perl program that shows the use of the substr method.
my $quote= "My dog has very sharp teeth!";

#delete the word teeth
$quote= substr($quote,  -6);

print "$quote \n";
