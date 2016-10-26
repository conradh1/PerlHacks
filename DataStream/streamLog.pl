#!/usr/bin/perl


use strict;
use Date::Parse;


#  Takes the epoch time of a date and prints the log file if the difference
# if greater than 10 seconds.
my @stream;

use constant MAXTIME => 10;



while(<>){        #reads lines until end of file or a Control-D from the keyboard
   push ( @stream, $_);
}

my $pivot = 0;

foreach ( @stream ) {
     my $line = $_;
     my $stamp = '';

     #[2016-10-03 22:39:12,272] [INFO] Downloading from datastore file B01480044.tar.gz within BatchID B01480044.
     # parse out message
     if ( $line =~ /\[(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}),\d{3}\].*$/ ) {
      $stamp = $1;
     }
     my $time = str2time($stamp);
     if ( $time - $pivot > MAXTIME ) {
	print $line;
	$pivot = $time;
     }

}


