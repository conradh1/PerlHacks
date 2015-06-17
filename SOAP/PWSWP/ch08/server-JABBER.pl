#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

# This daemon uses the SOAP-layer for WishListCustomer and
# the SOAP::Transport::JABBER::Server class by way of the
# WishListCustomer::Transport generic class for a transport
# method.
use strict;

use SOAP::Transport::JABBER;
# Loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;
use WishListCustomer::Transport
        'SOAP::Transport::JABBER::Server';

my ($user, $passwd, $host, $port) = @ARGV;
$host = 'jabber.org' unless $host;
$port = 5222         unless $port;
my $jabber_url = "jabber://$user:$passwd\@$host:$port";

# The constructor expects a string that looks like a URL,
# but with a leading sequence of "jabber://". The string
# will provide the connection and authentication data for
# reaching the Jabber server.
my $server = WishListCustomer::Transport
    ->new($jabber_url)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP' })
    ->objects_by_reference('WishListCustomer::SOAP');

while (1) {
    $server->handle;
    sleep 10;
}

exit 0;
