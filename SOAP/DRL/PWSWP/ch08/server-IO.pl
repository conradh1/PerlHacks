#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

# This example uses the SOAP-layer for WishListCustomer and
# the SOAP::Transport::IO::Server class by way of the
# WishListCustomer::Transport generic class for a transport
# method.
use strict;

use SOAP::Transport::IO;
# Loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;
use WishListCustomer::Transport
        'SOAP::Transport::IO::Server';

# The constructor could take parameters for the input and
# output filehandles, but this application is going to act
# as an ordinary filter, so the defaults of STDIN and STDOUT
# are fine.
my $server = WishListCustomer::Transport
    ->new()
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP' })
    ->objects_by_reference('WishListCustomer::SOAP')
    ->handle;

exit 0;
