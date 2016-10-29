#!/usr/local/bin/perl -- -*-perl-*-
#This program uses hashes


use strict;

my @days= ('Sunday', 'Saturday', 'Friday', 'Thursday', 'Wednesday', 'Tuesday', 'Monday');

my %week = (
	    Monday=>1,
	    Tuesday=>2,
	    Wednesday=>3,
	    Thursday=>4,
	    Friday=>5,
	    Saturday=>6,
	    Sunday=>7
	    );

my %new_week;

my $day_num= 7;
foreach $_ (@days) {
    $new_week{$_}= $day_num;
    $day_num--;
}

foreach $_ (sort { $new_week{$a} <=> $new_week{$b} } keys %new_week) {
    #sorts hash by value, notice reserved strings $a and $b
    print $_, '=', $new_week{$_}, "\n";
}

