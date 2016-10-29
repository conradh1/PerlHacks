#!/usr/local/bin/perl -- -*-perl-*-
#This is a perl program that tests the date and readin info

use Time::localtime;
use strict;

my $date = localtime()->hour.":".localtime()->min.":".localtime()->sec;
print "What is your name ? ";
my $line= <STDIN>;
chop($line); #get rid of the \n

print "Hello $line, the date today is $date \n";
my $year= localtime()->year() + 1900;
print "Year is $year\n";
my $month= localtime()->mon() + 1;
my $day= localtime()->mday();
print "Month is $month and the day is $day\n";

