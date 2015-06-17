#!/usr/bin/perl -w
use strict;

my $str= "Mozilla/2.0 (compatible; MSIE 3.02; Windows NT; MSIE 6.0; 240x320)";
my @pixels= ();
@pixels= split(/([^\d{3}x\d{3}])/gi, $str);
print "$str\n";
if ($str =~ /Windows[^CE]+MSIE/i) {
	print "Regular Expression matched.\n";
}
else {
	print "No match.\n";
}
foreach (@pixels) {
	if ($_=~ /(\d{3}x\d{3})/) {
		print "$_\n";
	}
}
