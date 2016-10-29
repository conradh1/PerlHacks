#!/usr/bin/perl -w
use strict;

my @str= (" trailing spaces INBETWEEN    ",
         "    LEADING Spaces",
         "TRAILING Spaces      ");

foreach (@str) {
  print "string before |$_|\n";
  print "string after trim: |".trim($_)."|\n\n";
}

#******************************************************************************
#************************ trim_value ******************************************
sub trim {
 #trims spaces front and back from a given value
 my ($str)= @_;
 $str=~ s/^\s+//; #get rid of front spaces
 $str=~ s/\s+$//; #get rid of rear spaces
 return $str;
}
