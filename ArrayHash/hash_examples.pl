#!/usr/bin/perl --
use strict;


# simple asigning

my %hash = (  'key1' => 1,
	      'key2' => 2
	   );


$hash{'key3'} = 3;


for my $key ( sort keys %hash ) {
  my $value = $hash{$key};
  print "$key => $value\n";
}

my $key4 = 'key4';
if ( exists($hash{$key4}) ) {
  print "There is  $key4  value => $hash{$key4}\n.";
}
else {
  print "There is no $key4 \n";
  $hash{ $key4 } = 4;
}

if ( exists($hash{$key4}) ) {
  print "There is  $key4  value => $hash{$key4}\n";
}

# clear teh hash
undef( %hash );

my %hash = (
    flintstones    => [ "fred", "barney" ],
    jetsons        => [ "george", "jane", "elroy" ],
    simpsons       => [ "homer", "marge", "bart" ],
);


$hash{teletubbies} = [ "tinky winky", "dipsy", "laa-laa", "po" ];

# add members
push @{ $hash{flintstones} }, "wilma", "pebbles";

for my $family ( keys %hash ) {
    print "$family: ";
    for my $i ( 0 .. $#{ $hash{$family} } ) {
        print " $i = $hash{$family}[$i]";
    }
    print "\n";
}