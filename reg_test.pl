#!/usr/bin/perl -w
use strict;

my $str= "Math is  \"fun\", 'challenging', and \"stimulating\" for sure!";
my $lookup= "";
my $lookdown= $str;
my @lookup= split(/(\"[^\"]+\")/g , $str);
$lookdown=~ s/[\"\'][^\"\']+[\"\']//gi;
#$lookup=~ s/(\'(([^\'])*([^\\\']([\]{2})*[\]\'([^\'])*)*[^\\\'])*([\]{2})*([\]\')*\')|("(([^"])*([^\\"]([\]{2})*[\]"([^"])*)*[^\\"])*([\]{2})*([\]")*"))/$1/gi;
foreach (@lookup) {
	print("$_\n");
        if ($_=~/\"([^\"]+)\"/gi) {
               $lookup.=$_;
        }
}
    print("##############################################\n".
	"####### strings are between pipes ##############\n".
	"String: \|$str\|\n".
	"##############################################\n".
	"Parsed: \|$lookdown\| in pattern.\n".
	"##############################################\n".
	"Extracted \|$lookup\| in pattern.\n".
	"##############################################\n");

exit 0;
