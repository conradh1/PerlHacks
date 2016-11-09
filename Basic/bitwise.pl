#!/usr/bin/perl
#---------------------#
#  PROGRAM:  binhexoct.pl  #
#---------------------#

# Program plays with datatypes.
# $number = oct($hexadecimal);         # "0x2e" becomes 47
# $number = oct($octal);               # "057"  becomes 47
# $number = oct($binary);              # "0b101110" becomes 47





# print binary value


use integer;
 
$a = 60;
$b = 13;

print "Value of \$a = $a and value of \$b = $b\n";

my $c = $a & $b;
print "AND Value of \$a & \$b = $c\n";
printf("Binary: %#b & %#b = %#b\n", $a, $b, $c);

$c = $a | $b;
print "OR Value of \$a | \$b = $c\n";
printf("Binary: %#b | %#b = %#b\n", $a, $b, $c);


$c = $a ^ $b;
print "XOR Value of \$a ^ \$b = $c\n";
printf("Binary: %#b ^ %#b = %#b\n", $a, $b, $c);

$c = ~$a;
print "Value of ~\$a = $c\n";
printf("Binary: \~%#b  = %#b\n", $a, $c);

$c = $a << 2;
print "SHIFT LEFT Value of \$a << 2 = $c\n";
printf("Binary: %#b << 2 = %#b\n", $a, $c);

$c = $b >> 2;
print "Value of \$b >> 2 = $c\n";
printf("Binary: %#b >> 2 = %#b\n", $b,  $c);
