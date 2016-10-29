#!/usr/local/bin/perl -- -*-perl-*-

#This is a perl program that tests simply functions

use strict;

my $folks= 100;
my @arrays = (38,22,36);
my $quote= "U of A|U of T|U of L|U of C|U of W";
my @word = split('\|', $quote);
#my $date = `date +"%B %e/%y %X"`;
my $date = `date +"%A, %B, %Y at %r"`;
my $line;
my $count= 0;
my $test= 0;
#main program

print "$quote\n";

foreach (@word)
{
    print"word $count = $word[$count] \n";
    $count++;
}
print"\n";
print "folks = $folks \n";
print "\n \a \LHELLO! \n";

chop $date;

print "Date when chopping carriage return: [".$date."]\n";
print "numbers are ".join(' ',@arrays)." \n";

open(HANDLE, "test_file.txt") || die "\n $0 Cannot open $!\n";

readfile(\*HANDLE);

print "\nFound \"This\" in the test file $count times!\n";

seek (HANDLE, 0, 0); #beginning of file
close(HANDLE);

sub readfile {

    my ($HANDLE)= @_;
    $count= 0;

    while (<$HANDLE>)
    {
	$line = $_;
	if ($line =~ /This/)
	{
	    $count++;
	}

    }

}
exit 0;

#end of test program







