#!/usr/bin/perl
#---------------------#
#  PROGRAM:  binhexoct.pl  #
#---------------------#

# Program plays with datatypes.
# $number = oct($hexadecimal);         # "0x2e" becomes 47
# $number = oct($octal);               # "057"  becomes 47
# $number = oct($binary);              # "0b101110" becomes 47




my $num = 255;
chomp $num;
exit unless defined $num;
$num = oct($num) if $num =~ /^0/; # catches 077 0b10 0x20
printf "Dec: %d Hex:%#x Oct: %#o  Binary: %#b\n", ($num) x 4;


my $hex = "0xff";

my $dec = oct( $hex );

print "Hex: $hex to Dec: $dec\n";


$num= 64;

my $bin = sprintf("%b",$num);

my @bits = split(//,$bin);

my $total = 0;

foreach ( @bits ) {
    $total += $_;
}

if ( $total == 1 ) {
 print "$num is a power of two.\n";
}
else {
    print "$num is NOT a power of two.\n";
}
