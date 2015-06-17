#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# The third version of the HTTP::Daemon-based server uses
# the SOAP layer with the FindBooks method in place of the
# two original search methods. Note that this will not
# correctly handle the authentication because of the
# coupling between the WishListCustomer::Daemon and the
# WishListCustomer::SOAP classes.
#
use strict;

use WishListCustomer::SOAP2;
use WishListCustomer::Daemon;

my $port = pop(@ARGV) || 9000;
my $host = shift(@ARGV) || 'localhost';

WishListCustomer::Daemon
    ->new(LocalAddr => $host, LocalPort => $port,
          Reuse => 1)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP2' })
    ->objects_by_reference('WishListCustomer::SOAP2')
    ->handle;

exit 0;
