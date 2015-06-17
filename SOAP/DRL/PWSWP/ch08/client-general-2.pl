#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This is a sample client that calls the SOAP interface on
# the specified endpoint using a one-way protocol. It sends
# a request to purchase one or more books from the wish-
# list.
#
use strict;

use WishListCustomer::Client;
use Sys::Hostname 'hostname';

my ($user, $passwd, $endpoint) = (shift, shift, shift);
die "USAGE: $0 username passwd endpoint ISBN [ ISBN... ]\n"
    unless ($user and $passwd and $endpoint and @ARGV);

if (substr($endpoint, 0, 3) eq 'ftp') {
    my @time = localtime;
    my $file = sprintf("%s-%02d%02d%02d:%02d%02d.xml",
                       $user,
                       $time[5] % 100, # year
                       $time[4] + 1,   # month
                       $time[3],       # day
                       $time[2],       # hour
                       $time[1]);      # minute
    $endpoint .= '/'
        unless (substr($endpoint, -1, 1) eq '/');
    $endpoint .= $file;
} elsif (substr($endpoint, 0, 6) eq 'mailto') {
    my $hostname = eval { hostname };
    $hostname = 'localhost' if $@;
    $endpoint = "$endpoint?From=$user\@$hostname&Subject=" .
        'SOAP';
} else {
    die "$0: endpoint only supports ftp: and mailto: ";
}

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
