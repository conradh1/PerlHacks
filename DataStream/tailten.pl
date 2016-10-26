#!/usr/bin/perl

use strict;


my @stream;
my $max = 9;


while(<>){        #reads lines until end of file or a Control-D from the keyboard
   push ( @stream, $_);
}

# case under 10 lines
if ( $#stream <= $max ) {
  foreach ( @stream ) {
    print ( $_ );
  }
}
for ( my $i = ($#stream-$max); $i <= $#stream; $i++) {
  print ( $stream[$i] );
}