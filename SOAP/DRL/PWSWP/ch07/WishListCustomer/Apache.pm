# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
#
# The sample Apache-binding layer for the Chapter 7 SOAP
# example.
#
package WishListCustomer::Apache;

use strict;
use vars qw(@ISA);

#
# In addition to loading the SOAP::Transport::HTTP module,
# The WishListCustomer::SOAP module is loaded here so that
# it is available immediately, without SOAP::Lite having
# to load it on-demand.
#

use SOAP::Transport::HTTP;
use WishListCustomer::SOAP;
@ISA = qw(SOAP::Transport::HTTP::Apache);

1;

#
# The only routine that needs to be overloaded to use the
# existing Apache code is this one. This version looks for
# any cookies in the incoming request and stores them in a
# hash table local to the WishListCustomer::SOAP module.
# It then passes the request on to the original version of
# this method.
#
sub handler ($$) {
    my ($self, $request) = @_;

    my $cookies = $request->header_in('cookie');
    my @cookies = ref $cookies ? @$cookies : $cookies;
    %WishListCustomer::SOAP::COOKIES = ();
    for my $line (@cookies) {
        for (split(/; /, $line)) {
            next unless /(.*?)=(.*)/;
            $WishListCustomer::SOAP::COOKIES{$1} = $2;
        }
    }

    $self->SUPER::handler($request);
}
