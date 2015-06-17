#!/usr/local/bin/perl -- -*-perl-*-

#helloworld.pl
#simple perl program to say hello

use strict; #use strict protocol rules
use Time::localtime;

my $date = ctime();

print "Hello World ! \n The date today is $date \n";
my $year= localtime()->year() + 1900;
print "Year is $year\n";
my $month= localtime()->mon() + 1;
my $day= localtime()->mday();
print "Month is $month and the day is $day\n";


