#!/usr/bin/perl -w
use strict;

my $str= $ARGV[0];
print("Before: |$str|\n");
#$str =~ s/([^\\])\\{1}([^\\]*)/$1\\\\$2/gi;
#$str =~ s/^\\{2}([^\\])/\\\\$1/gi;
$str = join('\\\\', split /\\/, $str);
print("After: |$str|\n");
#
#
exit 0;

