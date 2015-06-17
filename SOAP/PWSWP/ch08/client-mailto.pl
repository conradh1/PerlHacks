#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This is a sample client that calls the SOAP interface on
# the specified endpoint using the MAILTO protocol. It sends
# a request to purchase one or more books from the wish-
# list.
#
use strict;

use WishListCustomer::Client;
use Sys::Hostname 'hostname';

my ($user, $passwd, $mailto) = (shift, shift, shift);
die "USAGE: $0 username passwd endpoint ISBN [ ISBN... ]\n"
    unless ($user and $passwd and $mailto and @ARGV);

my $hostname = eval { hostname };
$hostname = 'localhost' if $@;
my $endpoint = sprintf("maito:%s?From=%s&Subject=SOAP",
                       $mailto,
                       "$user\@$hostname");

# Create the SOAP handle, using the class that manages the
# authentication data
my $soap = WishListCustomer::Client
               ->uri('urn:WishListCustomer')
               ->proxy($endpoint);
# Set the authentication credentials
$soap->setAuth($user, $passwd);
# ...and call the PurchaseBooks method, checking for errors
my $result = $soap->PurchaseBooks(\@ARGV);
if ($result->fault) {
    die "$0: Operation failed: " . $result->faultstring;
} else {
    print "Request sent\n";
}

exit;
