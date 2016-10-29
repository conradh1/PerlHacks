#!/usr/local/bin/perl -- -*-perl-*-

#This program tests the Math:BigFloat perl module
use strict;
use Math::Complex;
use Math::BigFloat;
use Math::BigInt;
use POSIX;
my $num= 0;
my $equation= 5/13*100;
my $float = new Math::BigFloat $equation; 
my $number= $float->fround(2);
my $test_num= 10;
$num= $equation;
print"The number in scientific notation using Math: $number \n";
printf("The number to two decimal places with C syntax: %.2f\n", $num);
$test_num= 10 % 2;
printf("10 \% 2 equals $test_num\n");
$test_num= 10 % 3;
printf("10 \% 3 equals $test_num\n");
$test_num= 10 / 3;
printf("10 / 3 equals $test_num\n");


