#!/usr/local/bin/perl -- -*-perl-*-

#stdin.pl
#This is a perl program that tests the date and readin info

use Time::localtime;
use strict;

my $date = ctime();
print "What is your name ?";
my $line= <STDIN>;
chop($line); #get rid of the \n

print "Hello $line, the date today is $date \n";


