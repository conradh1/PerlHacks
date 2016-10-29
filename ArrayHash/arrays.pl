#!/usr/bin/perl
@array1 = ('1', '2', '3', '4','5');
@array2 = ('a', 'b', 'c', 'd', 'e');
@array3 = ('A', 'B', 'C', 'D', 'E');

my $x = 0;
my @list = ();

for ($k=0; $k<= $#array1; $k++) {
   push @{ $list[$x] }, $array1[$k];
}
$x++;
for ($k=0; $k<= $#array2; $k++) {
   push @{ $list[$x] }, $array2[$k];
}
$x++;
for ($k=0; $k<= $#array1; $k++) {
   push @{ $list[$x] }, $array3[$k];
}

print "array size".$#{$list[0]}." 2d $#list \n";

for ($j=0; $j<=$#{$list[0]}; $j++) {
  for ($k=0; $k<=$#list; $k++) {
    print $list[$k][$j]," .. ";
  }
  print "\n";
} 

