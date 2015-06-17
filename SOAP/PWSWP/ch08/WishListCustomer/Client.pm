# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
package WishListCustomer::Client;

use strict;
use vars qw(@ISA);
use subs qw(setAuth call);

use WishListCustomer; # For make_cookie
use SOAP::Lite;
@ISA = qw(SOAP::Lite);

1;

# Create a SOAP::Header instance and store it on the object.
# If called with no parameters at all, the the header is
# cleared out. The header will contain the cookie data in
# the format that the existing WishListCustomer code is
# expecting.
sub setAuth {
    my ($self, $user, $passwd, @rest) = @_;

    if ($user and $passwd) {
        my $cookie =
            WishListCustomer::make_cookie($user, $passwd);
        $self->{__auth_header} =
            SOAP::Header->name(authenticate => $cookie)
                        ->uri('urn:WiahListCustomer');
        if (@rest) {
            # This extra block allows the user to specify
            # extra parts such as forcing mustUnderstand
            # or setting the namespace URI for the header.
            my %attr = @rest;
            $self->{__auth_header}->attr(%attr);
        }
    } else {
        delete $self->{__auth_header};
    }

    $self;
}

# This overloading of call() allows the calling object to
# insert the authentication header, if one is set. The
# argument set is simple, and the only concern is adding
# a header to @args.
sub call {
    my ($self, $method, @args) = @_;

    unshift(@args, $self->{__auth_header})
        if $self->{__auth_header};
    $self->SUPER::call($method, @args);
}
