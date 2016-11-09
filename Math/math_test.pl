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

$test_num = 8 ** 2;
printf("8 squared $test_num\n");

print "log10(1000): ", log(1000)/log(10), "\n";
print "sqrt(4): ", sqrt(4), "\n";
print "abs(-4: ", abs(-4), "\n";
my $r = int rand(10);
print "Random number between 1-10: ", $r, "\n";