#!/usr/local/bin/perl -- -*-perl-*-
#This program uses the shift,upshift, push and pop methods 
#to show the power of lists in Perl.
use strict;

my @word = ("di","tri","tetra","penta","hexa");

print "Original Array: ".join(' ',@word)."\n"; 
###############################################
#removes the last index in the arrray (pop)
pop(@word); 

print "Popped Array: ".join(' ',@word)."\n"; 
###############################################
#removes the first index in the array (dequeue)
shift(@word);

print "Shifted Array: ".join(' ',@word)."\n"; 
###############################################
#add to the top of the list in the array (enqueue)
unshift(@word,"mono");
 
print "Unshifted Array: ".join(' ',@word)."\n"; 
###############################################
#add an last index in the array (push)
push(@word,"hepta");

print "Pushed Array: ".join(' ',@word)."\n"; 
#multidimensional arrays
###############################################
my @list = (['1','2','3'],['A','B','C'], ['Alpha','Beta','Gamma']);
print "########################################\n";
my $rows= scalar(@list);

for (my $i= 0; $i < $rows; $i++) {
  my $cols= scalar(@{@list[$i]});
  for (my $j= 0; $j < $cols; $j++) {
    print $list[$i][$j]."|";
  }
  print "\n";
}
print "Rows= $rows ";
###############################################
exit 0;
#end of test program

###############################################

