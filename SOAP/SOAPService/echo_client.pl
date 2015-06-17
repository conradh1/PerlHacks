#!/usr/bin/perl –w
# Filename: echo_client.pl
# Client to send a message to the echo Web service
# Author: Byrne Reese byrne@majordojo.com
# Usage:
#    echo_client.pl <what to echo>
###################################################
use SOAP::Lite 'trace','debug';

$HOST   = "http://ambon.ifa.hawaii.edu/cgi-bin/echo.cgi";
$NS     = "http://ambon.ifa.hawaii.edu/Echo";
$PHRASE =  "helloworld"; # read from the command line
my $soap = SOAP::Lite
           -> uri($NS)
           -> on_action( sub { join '/', $NS, $_[1] } )
           -> proxy($HOST);

my $som = $soap->echo(SOAP::Data->name("whatToEcho" => "$PHRASE"));

print $som->result;
print "\n";

1;