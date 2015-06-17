#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This sample client is much simpler than the previous one,
# as it is only intended to demonstrate the flexibility of
# having the single-entry search interface that uses the
# parameter name to help in forming the search.
#
use strict;

use SOAP::Lite;

my ($type, $string) = (shift, shift);
die "USAGE: $0 { author | title } pattern [ endpoint ]\n"
    unless ($type and $string);
my $endpoint = shift || 'http://localhost.localdomain:9000';

# Simple creation of the SOAP handle
my $soap = SOAP::Lite->uri('urn:WishListCustomer')
               ->proxy($endpoint);

#
# Instead of just passing the value, encode it with the
# SOAP::Data class and give it a specific name. As always,
# check for errors.
#
my $result = $soap->FindBooks(SOAP::Data->name($type,
                                               $string));
if ($result->fault) {
    die "$0: Operation failed: " . $result->faultstring;
}
my $books = $result->result;

# This is a simpler format because we called it as a static
# method, which means less data returned.
format =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @>>>>>>>>>>>>>>>>>
$result->{title},                         $result->{isbn}

.

for (@$books) {
    $result = $soap->GetBook($_);
    # Quietly skip books that cause faults
    next if ($result->fault);
    $result = $result->result;
    write;
}

exit;
