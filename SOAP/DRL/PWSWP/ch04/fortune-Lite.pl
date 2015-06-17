#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

use XRFortune;
use XMLRPC::Transport::HTTP;

# For each of the three routines from the XRFortune package
# that will be made available to clients, the server needs a
# front-end wrapper that strips the first argument from the
# parameters list. This is because XMLRPC::Lite calls the
# routines as if they were static class methods.
BEGIN {
    no strict 'refs';

    for my $method qw(books fortune weighted_fortune) {
        *$method = sub { shift; XRFortune::$method(@_) };
    }
}

# The constructor returns the object reference, which is
# then used to chain a call to dispatch_to() that sets up
# the three local routines to be made available to clients.
# That also returns the object ref, which is used to
# chain along to the handle() method, which doesn't return
# until a signal interrupts the program.
XMLRPC::Transport::HTTP::Daemon
    ->new(LocalPort => 9000, ReuseAddr => 1)
    ->dispatch_to(qw(books fortune weighted_fortune))
    ->handle;

exit;
