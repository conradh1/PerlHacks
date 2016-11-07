#!/usr/local/bin/perl -- -*-perl-*-

#playpen.pl
#This is a perl program that does random problems based on arguments

use strict;
use Switch;
use FileHandle;

my @problems = ( "IP - Valid IP address",
		"BW - Biggest Word in a File.",
		"WA - Average Length of Words in a file.",
		"SS - Sort sentence from longest word to shortest");

print "Enter a letter to see a solution ?\n";

foreach my $problem ( @problems ) {
  print ( $problem."\n");
}
my $input= <STDIN>;
chop($input); #get rid of the \n
my $input = uc($input);

switch ( $input ) {

  case "IP" { print "Enter an IP ?";
	      my $ip = <STDIN>;
	      chop( $ip );
	      validIP( $ip );
            }

  case "BW" {
	      print "Enter a file name: ";
	      my $file = <STDIN>;
	      chop( $file );
	      biggestWord( $file );


	    }
  case "WA" {
	print "Enter a file name: ";
	my $file = <STDIN>;
	chop( $file );
	wordLengthAvg( $file );
      }
  case "SS" {
	print "Type a sentence: ";
	my $sentence = <STDIN>;
	chop( $sentence );
	sortWords( $sentence );
      }

  else {
	  print "Invalid option\n";
	}


}

#############################
# Checks for Valid IP address.
##############################
sub validIP() {
  my ($ip) = @_;

  my $valid = 1;

  if ( $ip =~  /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/gi ) {
    my @nums = split(/\./,$ip);  # split into sections

    foreach ( @nums ) {
      if ( $_ < 0 || $_ > 255 ) {
	$valid = 0;
	last;
      }

    }
  }
  else {
    $valid = 0;
  }

  if ( $valid ) {
    print "IP Address $ip is valid.\n";
  }
  else {
    print "IP Address $ip is NOT  valid.\n";
  }

} #validIP


#############################
# Checks for biggest word in a file
##############################
sub biggestWord() {
  my ($file) = @_;

  my $bw = '';
  my $length = -1;
  my $fh = new FileHandle;
  $fh->open($file, "r") || die "\n $0 Cannot open $!\n";

  while (<$fh>) {
        my @words = split(/\s/,$_);
        foreach my $word ( @words) {
	  if ( length($word) > $length ) {
	    $length = length($word);
	    $bw = $word;
	  }
        }
  }
  $fh->close;

  print "Biggest Word: $bw with length: $length\n";
} #validIP


#############################
# Calcuates average word length
##############################
sub wordLengthAvg() {
  my ($file) = @_;

  my $total_length = 0;
  my $total_words = 0;

  my $fh = new FileHandle;
  $fh->open($file, "r") || die "\n $0 Cannot open $!\n";

  while (<$fh>) {
        my @words = split(/\s/,$_);
        foreach my $word ( @words) {
	  $total_length += length($word);
	  $total_words++;
        }
  }
  $fh->close;

  my $av = $total_length/$total_words;
  #print "Total length $total_length Total Words: $total_words\n";
  printf("Average word length: %.2f\n", $av);
} #validIP


#############################
# sorts sentence by word length
##############################
sub sortWords() {

my ($sentence) = @_;

my %list;


my @words = split(/\s/,$sentence);

  foreach my $word ( @words ) {
    $list{$word} = length($word);
  }


  foreach my $word (reverse sort { $list{$a} <=> $list{$b} or $a cmp $b } keys %list) {
    print "$word ";
  }
  print "\n";
}

