# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
#
# The sample daemon class derived by sub-classing the
# SOAP::Transport::HTTP::Daemon class, which is in turn
# derived from HTTP::Daemon.
#
package WishListCustomer::Daemon;

use strict;
use vars qw(@ISA);

use SOAP::Transport::HTTP;
@ISA = qw(SOAP::Transport::HTTP::Daemon);

1;

#
# This is the only method that needs to be overloaded in
# order for this daemon class to handle the authentication.
# All cookie headers on the incoming request get copied to
# a hash table local to the WishListCustomer::SOAP
# package. The request is then passed on to the original
# version of this method.
#
sub request {
    my $self = shift;

    if (my $request = $_[0]) {
        my @cookies = $request->headers->header('cookie');
        %WishListCustomer::SOAP::COOKIES = ();
        for my $line (@cookies) {
            for (split(/; /, $line)) {
                next unless /(.*?)=(.*)/;
                $WishListCustomer::SOAP::COOKIES{$1} = $2;
            }
        }
    }

    $self->SUPER::request(@_);
}
