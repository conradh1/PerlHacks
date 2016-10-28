#!/usr/local/bin/perl -- -*-perl-*-

#readfile.pl
#This is a perl program that searches a log file for a specific time range.
use strict;
use FileHandle;
use Date::Parse;
use Time::Local;
my ($start,$end,$file);
print "Enter log file:";
my $file= <STDIN>;
chop($file);
print "Enter start time in YYYY-MM-DD HH:MM:SS (i.e. 2016-10-03 22:39:43): ";
my $start= <STDIN>;
chop($start);
print "Enter end time in YYYY-MM-DD HH:MM:SS (i.e.  2016-10-03 22:39:43): ";
my $end= <STDIN>;
chop($end);


if ( $start =~ /(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})/ ) {
      $start = timelocal($6,$5,$4,$3,$2,$1);
}

if ( $end =~ /(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})/ ) {
      $end = timelocal($6,$5,$4,$3,$2,$1);
}

my $fh = new FileHandle;
$fh->open($file, "r") || die "\n $0 Cannot open $!\n";

while (<$fh>) {
  my $line = $_;
  my $time;


  if ( $line =~ /\[(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2}),\d{3}\].*$/ ) {
      $time = timelocal($6,$5,$4,$3,$2,$1);
  }
     #my $time = str2time($stamp);
     if ( $time >= $start && $time <= $end ) {
	print $line;
     }
}
$fh->close;

exit 0;
#end program
