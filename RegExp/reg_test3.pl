#!/usr/bin/perl -w

print "enter string\n";
my $str= <STDIN>;
my ($str1, $str2);
chomp($str);

my $str3= $str1.$str.$str2;

if ($str =~ /[x|\*]/gi) {
	print("String |$str| exp matched.\n");	
}
else {
	print("String |$str| not matched.\n"); 
}
exit 0;

