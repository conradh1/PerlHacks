#!/usr/local/bin/perl -- -*-perl-*-

#readfile.pl
#This is a perl program that tests simply file functions
use strict;
use FileHandle;
print "Enter name of file: ";
my $file= <STDIN>;
chop($file);
my $fh = new FileHandle; 
$fh->open($file, "r") || die "\n $0 Cannot open $!\n";

while (<$fh>) {
        print($_);
}
$fh->close;

exit 0;
#end program
