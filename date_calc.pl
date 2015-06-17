#!/usr/bin/perl
#******************************************************************************
## date_calc.cgi  - Example of the date calc lib
##
## Created: April 06, 2004
## Author: Conrad Holmberg
##
##******************************************************************************
use strict;
use Date::Calc qw(Today
                  Add_Delta_YMD
                  Month_to_Text
                  check_date
                  Decode_Month
                  Delta_Days
                 );


my @from_dates= (20,1,2004);
my @to_dates= (1,3,2004);

my $Dd = Delta_Days($from_dates[2],$from_dates[1],$from_dates[0],
                                       $to_dates[2],$to_dates[1], $to_dates[0]);

print "Days difference: $Dd\n";

my ($yyyy, $mm, $dd)= Today;

my ($set_y, $set_m, $set_d) = Add_Delta_YMD($yyyy, $mm, $dd, 0, 0, -5);

print "Five days ago: $set_y, $set_m, $set_d\n";

