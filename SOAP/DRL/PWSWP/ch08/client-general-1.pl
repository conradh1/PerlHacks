#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This is a sample client that calls the SOAP interface on
# the specified endpoint (defaulting to a local address) and
# gets the wishlist for the specified user. The data is
# given a simple formatting by means of a format-picture.
#
use strict;

use WishListCustomer::Client;

my ($user, $passwd) = (shift, shift);
die "USAGE: $0 username passwd [ endpoint ]\n"
    unless ($user and $passwd);

my $endpoint = shift || 'tcp://localhost:9000';

# Create the SOAP handle, using the class that manages the
# authentication data
my $soap = WishListCustomer::Client
               ->uri('urn:WishListCustomer')
               ->proxy($endpoint);
# Set the authentication credentials
$soap->setAuth($user, $passwd);
# ...and call the Wishlist method, checking for errors
my $result = $soap->Wishlist;
if ($result->fault) {
    die "$0: Operation failed: " . $result->faultstring;
}
my $books = $result->result;

format =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<            @>>>>>>
$result->{title},                        $result->{us_price}
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @>>>>>>>>>>>>>>>>>
$result->{authors},                       $result->{isbn}

.

for (sort { $a->{title} cmp $b->{title} } @$books) {
    $result = $soap->GetBook($_->{isbn});
    # Quietly skip books that cause faults
    next if ($result->fault);
    $result = $result->result;
    write;
}

exit;
