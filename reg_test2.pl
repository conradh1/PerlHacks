#!/usr/bin/perl -w
use strict;

my $str= "<html><body>This is an <b>HTML</b> file.</body></html>";
my $lookdown= $str;
$lookdown=~ s/<[^>]+>//gi;
my $lookup= "";
#$lookup=~ s/(<[^>]+>)/$1/gi;
my @lookup= split(/(<[^>]+>)/g , $str);
foreach (@lookup) {
	if ($_=~/<[^>]+>/gi) {
		$lookup.=$_;
	}
}
print("##############################################\n".
	"String: \"$str\"\n".
	"##############################################\n".
	"Parsed \"$lookdown\" in pattern.\n".
	"##############################################\n".
	"Extracted \"$lookup\" in pattern.\n".
	"##############################################\n");

exit 0;

