#!/usr/bin/perl
#---------------------#
#  PROGRAM:  argv.pl  #
#---------------------#

$numArgs = $#ARGV + 1;
print "thanks, you gave me $numArgs command-line arguments.\n";

foreach $argnum (0 .. $#ARGV) {

   print "$ARGV[$argnum]\n";

}
