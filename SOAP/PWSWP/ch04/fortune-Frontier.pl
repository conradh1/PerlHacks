#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;

use XRFortune;
use RPC::XMLSimple::Daemon;

# The way the Daemon class in RPC::XMLSimple is set up, the
# constructor actually drops directly into the socket-accept
# loop, so there is no need to call any other method. The
# local routines are specified via the "methods" key on the
# input parameters. This package calls local routines as
# ordinary routines, not class methods, so there is no need
# for a wrapper class.
RPC::XMLSimple:Daemon->new(LocalPort => 9000,
                           ReuseAddr => 1,
                           methods =>
                           { books   => \&XRFortune::books,
                             fortune =>
                             \&XRFortune::fortune,
                             weighted_fortune =>
                             \&XRFortune::weighted_fortune
                           });

exit;
