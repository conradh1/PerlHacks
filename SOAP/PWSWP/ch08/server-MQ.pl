#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

# This daemon uses the SOAP-layer for WishListCustomer and
# the SOAP::Transport::MQ::Server class by way of the
# WishListCustomer::Transport generic class for a transport
# method.
use strict;

use SOAP::Transport::MQ;
# Loading this now saves effort for SOAP::Lite
use WishListCustomer::SOAP;
use WishListCustomer::Transport
        'SOAP::Transport::MQ::Server';

my ($chan, $mgr, $reqest, $reply, $host, $port) = @ARGV;
# Putting these last on the command-line allowed for default
# values to be used.
$host = 'localhost' unless $host;
$port = 9000        unless $port;
die "USAGE: $0 channel manager request_queue reply_queue " .
    '[ host port ]'
    unless ($chan and $mgr and $request and $reply);

my $mq_url = "mq://$host:$port?Channel=$chan;" .
    "QueueManager=$mgr;RequestQueue=$request;" .
    "ReplyQueue=$reply";

# The constructor expects a string that looks like a URL,
# but with a leading sequence of "jabber://". The string
# will provide the connection and authentication data for
# reaching the Jabber server.
my $server = WishListCustomer::Transport
    ->new($mq_url)
    ->dispatch_with({ 'urn:WishListCustomer' =>
                      'WishListCustomer::SOAP' })
    ->objects_by_reference('WishListCustomer::SOAP');

do { $server->handle } while sleep 1;

exit 0;
