#!/usr/local/bin/perl -- -*-perl-*-

#This program tests the Math:BigFloat perl module
use strict;
use Math::Complex;
use Math::BigFloat;
use Math::BigInt;
use POSIX;


#  Trying Math::BigFloat operations
# New BigFloat
my $float = new Math::BigFloat 5/13*100;
my $number= $float->fround(4); #four significant digits
print"The number in scientific notation using Math: $number \n";


# Without  Big Float
my $num = 5/13*100;
printf("The number to two decimal places with C syntax: %.2f\n", $num);


print "Testing DIV and Modulus\n";
my $test_num= 10;
$test_num= 10 % 2;
printf("10 \% 2 equals $test_num\n");
$test_num= 10 % 3;
printf("10 \% 3 equals $test_num\n");
$test_num= int(10/3);
printf("10 DIV 3 equals $test_num\n");
$test_num= 10.0 / 3.0;
printf("10.0 / 3.0 equals %.2f\n", $test_num);


