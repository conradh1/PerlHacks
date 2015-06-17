#!/usr/bin/perl -w
use strict;

my $str= "<img border=1>";
my $lookdown= $str;
$lookdown=~ s/<([^=]*=)([0-9])>/<$1\"$2\">/gi;
my $lookup= $str;
$lookup=~ s/<[a-zA-Z]+\s+([^=]*=)([0-9])>/$1\"$2\"/gi;
print("##############################################\n".
	"String: |$str|\n".
	"##############################################\n".
	"Parsed |$lookdown| in pattern.\n".
	"##############################################\n".
	"Extracted |$lookup| in pattern.\n".
	"##############################################\n");

exit 0;

