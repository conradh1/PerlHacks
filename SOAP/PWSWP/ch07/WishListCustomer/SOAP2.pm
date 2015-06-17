# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
#
# This is the sample SOAP layer as presented in the
# WishListCustomer::SOAP class, but with the FindBooks
# method instead of the BooksByAuthor and BooksByTitle
# methods. Hence, it cannot inherit from that class
# without exposing them. Only the changes parts of the
# code are documented.
#
package WishListCustomer::SOAP2;

use strict;
use vars qw(@ISA %COOKIES);

use SOAP::Lite;
use WishListCustomer;

#
# Adding SOAP::Server::Parameters to the inheritance
# tree enables the FindBooks method to access the
# deserialized request object.
#
@ISA = qw(WishListCustomer SOAP::Server::Parameters);

BEGIN {
    no strict 'refs';

    #
    # Note the absence of BooksByAuthor and BooksByTitle
    # from this list.
    #
    for my $method qw(GetBook Wishlist AddBook RemoveBook
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
# This replaces BooksBy{Author,Title} with a single
# interface that uses the name given to the input parameter
# to choose the type of search to execute.
#
sub FindBooks {
    my ($class, $arg, $env) = @_;

    #
    # Using the SOAP envelope of the request, get the
    # SOAP::Data object that wraps the value $arg was
    # assigned.
    #
    my $argname = $env->match(SOAP::SOM::paramsin)->dataof;
    my $hook = ($argname->name eq 'author') ?
                   \&SoapExBook::get_books_by_author :
                   \&SoapExBook::get_books_by_title;
    #
    # As with the originals, this can be a static method,
    # so the test to use a new book-database handle versus
    # the self-stored one is still present.
    #
    my $bookdb = ref($class) ? $class->{_catalog} :
                               SoapExBook::connect();
    return 'Unable to connect to catalog' unless $bookdb;

    my @books = $hook->($bookdb, $arg);
    \@books;
}

sub CanPurchase {
    my $self = shift->new;
    die SOAP::Fault->faultcode('Server.RequestError')
                   ->faultstring('Could not get object')
        unless $self;

    SOAP::Data->name('return', $self->SUPER::CanPurchase)
              ->type('xsd:boolean');
}
