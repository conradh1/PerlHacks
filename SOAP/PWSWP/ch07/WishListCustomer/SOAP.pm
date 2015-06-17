# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
#
# This is the sample SOAP layer built over the
# WishListCustomer class, as part of the exercises of
# chapters 7 and 8.
#
package WishListCustomer::SOAP;

use strict;
use vars qw(@ISA %COOKIES);

use SOAP::Lite;
use WishListCustomer;

@ISA = qw(WishListCustomer);

BEGIN {
    no strict 'refs';

    #
    # This block creates local versions of the methods
    # in the list. The local versions catch errors that
    # would otherwise be simple text, and turn them into
    # SOAP::Fault objects.
    #
    for my $method qw(GetBook BooksByAuthor BooksByTitle
                      Wishlist AddBook RemoveBook
                      PurchaseBooks) {
        eval "sub $method";
        *$method = sub {
            my $self = shift->new;
            die SOAP::Fault
                    ->faultcode('Server.RequestError')
                    ->faultstring('Could not get object')
                unless $self;

            my $smethod = "SUPER::$method";
            my $res = $self->$smethod(@_);
            die SOAP::Fault
                    ->faultcode('Server.ExecError')
                    ->faultstring("Execution error: $res")
                unless ref($res);

            $res;
        };
    }
}

1;

#
# The class constructor. It is designed to be called by each
# invocation of each other method. As such, it returns the
# first argument immediately if it is already an object of
# the class. This lets users of the class rely on constructs
# such as cookie-based authentication, where each request
# calls for a new object instance.
#
sub new {
    my $class = shift;
    return $class if ref($class);

    my $self;
    # If there are no arguments, but available cookies, then
    # that is the signal to work the cookies into play
    if ((! @_) and (keys %COOKIES)) {
        # Start by getting the basic, bare object
        $self = $class->SUPER::new();
        # Then call SetUser. It will die with a SOAP::Fault
        # on any error
        $self->SetUser;
    } else {
        $self = $class->SUPER::new(@_);
    }

    $self;
}

#
# This derived version of SetUser hands off to the parent-
# class version if any arguments are passed. If none are,
# it looks for cookies to provide the authentication. The
# user name is extracted from the cookie, and the "user"
# and "cookie" arguments are passed to the parent-class
# SetUser method with these values.
#
sub SetUser {
    my $self = shift->new;
    my %args = @_;

    return $self->SUPER::SetUser(%args) if (%args);

    my $user;
    my $cookie = $COOKIES{user};
    return $self unless $cookie;
    ($user = $cookie) =~ s/%([0-9a-f]{2})/chr(hex($1))/ge;
    $user =~ s/%([0-9a-f]{2})/chr(hex($1))/ge;
    $user =~ s/::.*//;

    my $res = $self->SUPER::SetUser(user   => $user,
                                    cookie => $cookie);
    die SOAP::Fault
            ->faultcode('Server.AuthError')
            ->faultstring("Authorization failed: $res")
        unless ref($res);

    $self;
}

#
# This method could not be relegated to the loop-construct
# in the BEGIN block above, because SOAP::Lite cannot tell
# instinctively that this method returns a boolean rather
# than an integer. So the value from the parent-class
# method is coerced into the correct encoding via the
# SOAP::Data class.
#
sub CanPurchase {
    my $self = shift->new;
    die SOAP::Fault->faultcode('Server.RequestError')
                   ->faultstring('Could not get object')
        unless $self;

    SOAP::Data->name('return', $self->SUPER::CanPurchase)
              ->type('xsd:boolean');
}
