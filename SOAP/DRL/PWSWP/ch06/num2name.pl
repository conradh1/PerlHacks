#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

# The SOAP::Lite package usually needs only this module loaded:
use SOAP::Lite;

# Simple command-line handling
my $num = shift;
$num =~ /^\d+$/ or die "USAGE: $0 num\n";

my ($server, $endpoint, $soapaction, $method, $method_urn, $message);
$server     = 'www.tankebolaget.se';
$endpoint   = "http://$server/scripts/NumToWords.dll/soap/INumToWords";
$soapaction =
    "http://$server/urn:NumToWordsIntf-INumToWords#NumToWords_English";
$method     = 'NumToWords_English';
$method_urn = 'urn:NumToWordsIntf-INumToWords';

# SOAP::Lite objects are inherently the client connections, so this
# will be used to make the remote calls
my $num2words = SOAP::Lite->new(uri   => $soapaction,
                                proxy => $endpoint);
my $response = $num2words->call(SOAP::Data
                                ->name($method)
                                ->attr( { xmlns => $method_urn } )
                                => # Argument(s) listed next
                                SOAP::Data->name(aNumber => $num));

# Responses from SOAP::Lite calls are already parsed and decoded,
# so the program need only check for errors and fetch results
if ($response->fault)
{
    printf "A fault (%s) occurred: %s\n",
        $response->faultcode, $response->faultstring;
}
else
{
    print "$num may be expressed as " . $response->result . "\n";
}

exit;
