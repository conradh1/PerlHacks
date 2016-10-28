#!/usr/local/bin/perl -- -*-perl-*-

#readfile.pl
#This is a perl program that seeks to the second last line
use FileHandle;


my $file= "test_seek.log";

print "Testing file seek...\n";

my $fh = new FileHandle; 
$fh->open($file, "r") || die "\n $0 Cannot open $!\n";
binmode $fh;


my $line = <$fh>;

{

require Encode;
my $bytes = Encode::encode_utf8($line);
my $n = (length $bytes)*-16;
#print "Debug $n \n";

seek($fh, $n, 2);
$line = <$fh>;
}

print "second last line:".$line."\n";

$fh->close;

exit 0;
#end program
