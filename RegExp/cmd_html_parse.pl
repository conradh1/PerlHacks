#!/usr/local/bin/perl -- -*-perl-*-
#This program parses html commands from a hash
use strict;

my @html_cmd;
my @html_arg;
my @html_end_tag;
my @html = ('<html>',
	   '<title>Test page</title>', 
	   '<body>This is a test page</body>', 
	   '</html>');

######### Start Main Program ##############
for (my $i= 0; $i <=  $#html; $i++) {    
    parse_arg($html[$i]);
    parse_start_tag($html[$i]);
    parse_end_tag($html[$i]);
    print("Start tag is: $html_cmd[$i]\n",
	  "Argument is: $html_arg[$i]\n",
	  "End tag is: $html_end_tag[$i]\n",
	  "######################\n"); 
}

######## End Main Program #################
sub parse_arg {    
    my ($arg)= @_;
    $arg=~ s/<[^>]+>//g;
    if ($arg eq "") { $arg= "empty"; }
    push(@html_arg, $arg);
}
###########################################
sub parse_start_tag {
    my ($cmd)= @_;
    if ($cmd=~ /(<[^>\/]+>)/g) {
	$cmd= $1;
    }
    else {
	$cmd= "empty";
    }
    push(@html_cmd, $cmd);
}
###########################################
sub parse_end_tag {
    my ($cmd)= @_;
    if ($cmd=~ /(<\/[^>]+>)/g) {
	$cmd= $1;
    }
    else {
	$cmd= "empty";
    }
    push(@html_end_tag, $cmd);
}
###########################################
