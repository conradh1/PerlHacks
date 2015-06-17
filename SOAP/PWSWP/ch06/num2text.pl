#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

# All four of these are from the Developmentor SOAP module
use SOAP::EnvelopeMaker;
use SOAP::Parser;
use SOAP::Struct;
use SOAP::Transport::HTTP::Client;

# Simple command-line handling
my $num = shift;
$num =~ /^\d+$/ or die "USAGE: $0 num\n";

my ($server, $endpoint, $soapaction, $method, $method_urn, $message);
$server     = 'www.tankebolaget.se';
$endpoint   = '/scripts/NumToWords.dll/soap/INumToWords';
$soapaction = 'urn:NumToWordsIntf-INumToWords#NumToWords_English';
$method     = 'NumToWords_English';
$method_urn = 'urn:NumToWordsIntf-INumToWords';

# These statements create the request body in the scalar $message
my $envelope = SOAP::EnvelopeMaker->new(\$message);
$envelope->set_body($method_urn, $method, 0,
                    SOAP::Struct->new(aNumber => $num));

# These create the request/client object and use it to make the
# actual request. The parser class (SOAP::Parser) is used to
# analyze and decode the result from the call.
my $response = SOAP::Transport::HTTP::Client->new()
                   ->send_receive($server, 80, $endpoint,
                                  $method_urn, $method, $message);
my $parser   = SOAP::Parser->new;
$parser->parsestring($response);
$response = $parser->get_body;
if (exists $response->{return})
{
    print qq($num may be expressed as "$response->{return}"\n);
}
else
{
    print "A fault ($response->{faultcode}) occurred: " .
        "$response->{faultstring}\n";
}

exit;
