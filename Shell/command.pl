#!/usr/local/bin/perl -- -*-perl-*-

#command.pl
#simple perl program to demostrate how to print
#the output of commands

use strict; #use strict protocol rules

print "The command below is a list (ls -al) done by Perl\n";
print `ls -al`;


