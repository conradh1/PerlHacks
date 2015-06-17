#!/usr/local/bin/perl -- -*-perl-*-

#parse_cmd.pl

#This perl program parses out commands between double hashes

use strict;

my $command= "";
my @cmd_arg;
my $pos= 0;
my @cmd = ('##TOP##This text','##PG:01##should not ', '##PG:03##output in this program.', '##BOTTOM##');

##################################
########## Main Program ############
foreach (@cmd) {
    
    	$_=~ /(\#\#[^\#]+\#\#)/g;
	$command= $1;
	$pos= find_hash($_);
   
    	print "cmd is $command\n";
}
######### End Program ##############
##################################
sub find_hash {
    
    my ($cmd)= @_;
    substr($cmd, 0, 2)= "";
    my $pos = rindex($cmd, "##");
    print "The number of characters within the hash are: $pos\n";
    return($pos);
}
##################################


