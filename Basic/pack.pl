#!/usr/bin/perl -w

$bits = pack("c", 65);
# prints A, which is ASCII 65.
print "bits are $bits\n";
$bits = pack( "x" );
# $bits is now a null chracter.
print "bits are $bits\n";
$bits = pack( "sai", 255, "T", 30 );
# creates a seven charcter string on most computers'
print "bits are $bits\n";

@array = unpack( "sai", "$bits" );


#Array now contains three elements: 255, T and 30.
print "Array $array[0]\n";
print "Array $array[1]\n";
print "Array $array[2]\n";



my $num = "A";
$bits = unpack("C",$num);
print "$num ASCII: |$bits|\n";


$word = pack("C*", 115, 97, 109, 112, 108, 101);   # same
print "Printing packed word $word\n";