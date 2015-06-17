#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# A simple server that does not yet do access-control on
# requests.
#

use strict;

use SOAP::Transport::HTTP;
# Loading this class here keeps SOAP::Lite from having to
# load it on demand.
use WishListCustomer;

my $port = pop(@ARGV) || 9000;
my $host = shift(@ARGV) || 'localhost';

SOAP::Transport::HTTP::Daemon
    ->new(LocalAddr => $host, LocalPort => $port,
          Reuse => 1)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer' })
    ->objects_by_reference('WishListCustomer')
    ->handle;

exit;
