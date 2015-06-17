#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

use XRFortune;
use RPC::XML::Server;

# The object created by the constructor will be used to
# chain on a set of calls to add_proc() (which means it
# isn't necessary to deal with the local routines being
# called as methods), and then drop directly into the
# server_loop() method.
RPC::XML::Server->new(port => 9000)
    # add_proc can take a pre-created RPC::XML::Procedure
    # object, or a hash reference.
    ->add_proc({ name => 'books',
                 signature => [ 'array',
                                'array string',
                                'array array' ],
                 code => \&XRFortune::books })
    # It gets called once for each routine being made
    # public by the server.
    ->add_proc({ name => 'fortune',
                 signature => [ 'array',
                                'array string',
                                'array array' ],
                 code => \&XRFortune::fortune })
    # There are other ways of specifying the server-side
    # procedures, but for an example of this size, this way
    # is just as efficient.
    ->add_proc({ name => 'weighted_fortune',
                 signature => [ 'array',
                                'array string',
                                'array array' ],
                 code => \&XRFortune::weighted_fortune })
    # This method will only return after a signal interrupts
    # it.
    ->server_loop;

exit;
