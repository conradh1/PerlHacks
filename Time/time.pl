#!/usr/local/bin/perl -- -*-perl-*-
#This is a perl program that tests the date and readin info

use Time::localtime;
use Time::Local;
my $date = localtime()->hour.":".localtime()->min.":".localtime()->sec;



print "Hello! The date today is $date \n";
my $year= localtime()->year() + 1900;
print "Year is $year\n";
my $month= localtime()->mon() + 1;
my $day= localtime()->mday();
print "Month is $month and the day is $day\n";

my $epoch_morning  = timelocal(0, 0,0,$day,localtime()->mon(),localtime()->year());
print "Epoch time this morning: $epoch_morning \n";
print "Epoch time now: ".time()."\n";
print "Number of seconds today: ".(time-$epoch_morning)."\n";

for (1..10) {
 print ('.');
 sleep(1);
}
print 'Done\n';
