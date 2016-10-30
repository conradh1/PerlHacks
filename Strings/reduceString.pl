#!/usr/local/bin/perl -- -*-perl-*-
# Shil has a string, , consisting of  lowercase English letters. In one operation, he can delete any pair of adjacent letters with same value. For example, string "" would become either "" or "" after  operation.
#
# Shil wants to reduce  as much as possible. To do this, he will repeat the above operation as many times as it can be performed. Help Shil out by finding and printing 's non-reducible form!
#
# Note: If the final string is empty, print .
#
# Input Format
#
# A single string, .
#
# Constraints
#
# Output Format
#
# If the final string is empty, print ; otherwise, print the final non-reducible string.
#
# Sample Input 0
#
# aaabccddd
# Sample Output 0
#
# abd
use strict;

my $str = <STDIN>;
my $reduce = '';
chop($str);

if ( $str !~ /(\w)\1/ ) {
  print "$str\n";
  exit 0;
}

while ( $str =~ /(\w)\1/ ) {
  $str =~ s/(\w)\1//;
  $reduce = $str;
}

if ( !defined($reduce) || $reduce eq '' ) {
  print "Empty String\n";
}
else {
  print "$reduce\n";
}
exit 0;

#end of test program




