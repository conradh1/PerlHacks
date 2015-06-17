#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

#
# Version 2 of the daemon, this time using a SOAP layer for
# the methods to expose, and a daemon class that derives
# from the original HTTP::Daemon-based class for the server
# layer. Combined, these allow for basic authentication of
# user operations.
#
use strict;

# Again, loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;
use WishListCustomer::Daemon;

my $port = pop(@ARGV) || 9000;
my $host = shift(@ARGV) || 'localhost';

WishListCustomer::Daemon
    ->new(LocalAddr => $host, LocalPort => $port,
          Reuse => 1)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP' })
    ->objects_by_reference('WishListCustomer::SOAP')
    ->handle;

exit 0;
