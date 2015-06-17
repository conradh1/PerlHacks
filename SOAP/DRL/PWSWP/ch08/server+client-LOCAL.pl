#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

# This example uses the SOAP-layer for WishListCustomer and
# the SOAP::Transport::LOCAL::Client class by way of the
# WishListCustomer::Transport generic class for a transport
# method.
use strict;

use SOAP::Lite;
# Loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;

my $pattern = shift || 'perl';
my $soap = SOAP::Lite->uri('urn:WishListCustomer')
                     ->proxy('local:');
$soap->transport
           ->dispatch_with({ 'urn:WishListCustomer',
                             'WishListCustomer::SOAP' });

my $result = $soap->BooksByTitle($pattern);
if ($result->fault) {
    die "$0: Operation failed: " . $result->faultstring;
}
my $books = $result->result;

format =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @>>>>>>>>>>>>>>>>>
$result->{title},                         $result->{isbn}
.

print "Books whose title matches '$pattern':\n\n";
for (@$books) {
    $result = $soap->GetBook($_);
    # Quietly skip books that cause faults
    next if ($result->fault);
    $result = $result->result;
    write;
}

exit 0;
