#!/usr/bin/perl
@array1 = ('1', '1', '2', '3','3', '4','4','5','6');

my $tmp = '';
my @list = ();

for ($k=0; $k<= $#array1; $k++) {
   if ($tmp ne $array1[$k]) {
     $tmp = $array1[$k];
     push @list, $tmp;
   }
}

print "new list: ";
foreach (@list) {
  print "|$_";
}

print "\n";

my $str = "3PI_P2_J000637_B001";
$str =~ s/^.*_.{2}_//gi;
$str =~ s/_B[0-9]{3}$//gi;
print ("$str \n");

