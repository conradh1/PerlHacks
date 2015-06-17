#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This is a sample client that calls the SOAP interface on
# the specified endpoint (defaulting to a local address)
# gets the wishlist for the specified user. The data is
# given a simple formatting by means of a format-picture.
# This client needed no updating even as the server was
# moved from HTTP::Daemon to Apache/mod_perl.
#
use strict;

use URI;
use HTTP::Cookies;
use SOAP::Lite;
# This is included only to avoid re-copying the cookie
# code.
use WishListCustomer; # for make_cookie

my ($user, $passwd) = (shift, shift);
die "USAGE: $0 username passwd [ endpoint ]\n"
    unless ($user and $passwd);

# To allow more flexibility in specifying the endpoint, the
# URI class is used on the URL to properly extract the host
# and port values for creating the cookies.
my $endpoint = shift || 'http://localhost.localdomain:9000';
my $uri = URI->new($endpoint);
my $cookie = WishListCustomer::make_cookie($user, $passwd);
my $cookie_jar = HTTP::Cookies->new();
$cookie_jar->set_cookie(0, user => $cookie, '/', $uri->host,
                        $uri->port);

#
# Create the SOAP handle, with access to the cookie...
#
my $soap = SOAP::Lite->uri('urn:WishListCustomer')
               ->proxy($endpoint,
                       cookie_jar => $cookie_jar);

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
