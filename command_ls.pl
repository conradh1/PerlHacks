#!/usr/local/bin/perl -- -*-perl-*-

#command.pl
#simple perl program to demostrate how to print
#the output of commands

use strict; #use strict protocol rules

print "The command below is a list (ls -t) done by Perl\n";
my $dir = "";
my @filelist= `ls -t $dir`;
print "directory $dir has ".($#filelist+1)." files.\n";
foreach my $file (@filelist) { 
 print "|$file|";
}


