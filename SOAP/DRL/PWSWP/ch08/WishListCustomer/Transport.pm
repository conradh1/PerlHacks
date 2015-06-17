# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
package WishListCustomer::Transport;

use strict;
use vars qw(@ISA);
use subs qw(import find_target);

use SOAP::Lite;

# For lack of a better default, SOAP::Server is given here.
# In fact, the expectation is that import() will change this
# at compile-time or run-time.
@ISA = qw(SOAP::Server);

1;

# Set the parent class that this class inherits from for
# all the server functionality. The purpose here is just
# to overload find_target (below).
sub import {
    my $class = shift;
    my $new_parent = shift;

    @ISA = ($new_parent);
}

# This overloading of the find_target method takes the
# (now) deserialized request object and looks for a header
# named "authenticate". If found, the value is stuffed into
# the same %WishListCustomer::SOAP::COOKIES hash table that
# the code already uses.
#
# This remains coupled to WishListCustomer::SOAP by virtue
# of the use of the %WishListCustomer::SOAP hash table.
sub find_target {
    my $self = shift;
    my $request = shift;

    %WishListCustomer::SOAP::COOKIES = ();
    my $header = $request->match(SOAP::SOM::header .
                                 '/authenticate')->dataof;
    if ($header) {
        my $key = $header->attr->{name} || 'user';
        my $value = $header->value;

        $value =~ s/\n\r\s//g;
        $WishListCustomer::SOAP::COOKIES{$key} = $value;
    }

    $self->SUPER::find_target($request);
}
