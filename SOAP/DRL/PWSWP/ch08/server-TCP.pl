#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# This daemon uses the SOAP-layer for WishListCustomer and
# the SOAP::Transport::TCP::Server class by way of the
# WishListCustomer::Transport generic class for a transport
# method.
#
use strict;

use SOAP::Transport::TCP;
# Loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;
use WishListCustomer::Transport
        'SOAP::Transport::TCP::Server';

my $port = pop(@ARGV) || 9000;
my $host = shift(@ARGV) || 'localhost';

# The constructor has to give a Listen argument with a
# value, something that HTTP::Daemon did automatically.
# Other than that, the only real difference is the use
# of WishListCustomer::Transport as the class to create
# the object from.
WishListCustomer::Transport
    ->new(LocalAddr => $host, LocalPort => $port,
          Listen => 5, Reuse => 1)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP' })
    ->objects_by_reference('WishListCustomer::SOAP')
    ->handle;

exit 0;
