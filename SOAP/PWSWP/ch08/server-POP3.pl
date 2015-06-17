#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This daemon uses the SOAP-layer for WishListCustomer and
# the SOAP::Transport::POP3::Server class by way of the
# WishListCustomer::Transport generic class for a transport
# method.
#
use strict;

use SOAP::Transport::TCP;
# Loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;
use WishListCustomer::Transport
        'SOAP::Transport::POP3::Server';

my ($user, $passwd, $host) = @ARGV;
$host ||= 'localhost';
my $pop3_url = "pop://$user:$passwd\@$host";

# The constructor takes a URL string that contains all the
# the needed information for connecting and authenticating
# with the POP3 server.
WishListCustomer::Transport
    ->new($pop3_url)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP' })
    ->objects_by_reference('WishListCustomer::SOAP');

do { $server->handle ) while sleep 10;

exit 0;
