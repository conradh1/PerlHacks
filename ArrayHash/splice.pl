#!/usr/local/bin/perl -- -*-perl-*-
#This is a perl program that shows the use of the splice method.

use strict;

my @floors = (12,14,15);
my $lucky_floor = 13;
my @lucky_floors = ('13a','13b');


print "The floors are: @floors\t".
      "The lucky floors are: @lucky_floors\t".
      "The number of floors is: ".($#floors+1)."\n";
#print the size of the array (last index + 1)

splice (@floors,1,0,$lucky_floor);
#inserts a element into the second position of the arrray that replaces zero elements

print "The floors spliced are: ";
foreach my $floor (@floors) {
    print "$floor ";
    # use of a foreach statement for an array
}
print "\tThe number of floors is: ".($#floors+1)."\n";

splice (@floors,1,2,@lucky_floors);
#inserts an array into the second position of the array replaceing two elements after it

print "The floors spliced again are: @floors \n";

exit 0;
