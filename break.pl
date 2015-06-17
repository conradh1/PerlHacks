#!/usr/local/bin/perl --
#break.pl
#example loop of using the last command as a break.
use strict;

my $counter= 0;

while ($counter <= 10) {
    
    if ($counter == 8) {
	print "Successful Break in while loop! \n";
	last;
    }

    else {
	print" counter = $counter \n";
	++$counter;
    }
}

print "Can this code be reached if last is called?\n";


