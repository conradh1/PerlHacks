# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
#
# The WishListCustomer package is the basis for the SOAP
# example in Chapters 7 and 8. It is a container class for
# two other interfaces, SoapExBook and SoapExUser.
#
package WishListCustomer;

use strict;
use subs qw(new GetBook BooksByAuthor BooksByTitle Wishlist
            AddBook RemoveBook CanPurchase PurchaseBooks
            SetUser make_cookie);

use Digest::MD5 'md5_hex';
use SoapExBook;
use SoapExUser;

1;

#
# The class constructor
#
sub new {
    my ($class, $user, $passwd) = @_;

    my $self = bless {}, $class;

    die "$!"
        unless $self->{_catalog} = SoapExBook::connect;

    if ($user and $passwd) {
        return undef
            unless $self->SetUser(user     => $user,
                                  password => $passwd);
    }

    $self;
}

#
# Initialize and load specific user information into the
# main object.
#
sub SetUser {
    my ($self, %args) = @_;

    $self->{_user} = SoapExUser->new();
    unless (ref($self) and $args{user} and
            $self->{_user}->get_user($args{user})) {
        undef $self->{_user};
        return "Could not load data for $args{user}";
    }

    # User data is loaded beforehand, so that the password
    # is available for testing. If the validation fails,
    # user object is destroyed before the error is sent, so
    # that the caller does not accidentally get the user
    # data.
    if ($args{password}) {
        unless ($args{password} eq $self->{_user}->passwd) {
            undef $self->{_user};
            return "Bad password for $args{user}";
        }
    } elsif ($args{cookie}) {
        unless ($args{cookie} eq
                make_cookie($args{user},
                            $self->{_user}->{passwd})) {
            undef $self->{_user};
            return "Auth token for $args{user} invalid";
        }
    } else {
        undef $self->{_user};
        return "No authentication present for $args{user}";
    }

    $self;
}

#
# Retrieve information on one specific book. May be called
# as a static method.
#
sub GetBook {
    my ($self, $isbn) = @_;

    # If this is called as a static method, then get a fresh
    # book-database connection. Otherwise, use the one that
    # is already available.
    my $bookdb = ref($self) ? $self->{_catalog} :
                              SoapExBook::connect();
    return 'Unable to connect to catalog' unless $bookdb;
    # If there is a valid user record, set the flag to
    # return extra information
    my $fullinfo = $self->{_user} ? 1 : 0;

    my $book = SoapExBook::get_book($bookdb, $isbn);
    return "No book found for key $isbn" unless $book;

    return { title => $book->{title},
             isbn  => $book->{isbn},
             url   => $book->{url},
             $fullinfo ?
             ( authors  => $book->{authors},
               us_price => $book->{us_price} ) :
             () };
}

#
# Retrieve a list of keys of books whose authors field
# contains the requested substring. May be called as a
# static method.
#
sub BooksByAuthor {
    my ($class, $author) = @_;

    # If this is called as a static method, then get a fresh
    # book-database connection. Otherwise, use the one that
    # is already available.
    my $bookdb = ref($class) ? $class->{_catalog} :
                               SoapExBook::connect();
    return 'Unable to connect to catalog' unless $bookdb;

    my @books =
        SoapExBook::get_books_by_author($bookdb, $author);
    \@books;
}

#
# Retrieve a list of keys of books whose title field
# contains the requested substring. May be called as a
# static method.
#
sub BooksByTitle {
    my ($class, $title) = @_;

    # If this is called as a static method, then get a fresh
    # book-database connection. Otherwise, use the one that
    # is already available.
    my $bookdb = ref($class) ? $class->{_catalog} :
                               SoapExBook::connect();
    return 'Unable to connect to catalog' unless $bookdb;

    my @books =
        SoapExBook::get_books_by_title($bookdb, $title);
    \@books;
}

#
# Return the current contents of the user's wish-list. The
# list contains abbreviated book information.
#
sub Wishlist {
    my $self = shift;

    # This is not callable as a static method, so it must
    # have a value user object stored within.
    return 'The object is missing user data'
        unless (ref($self) and my $user = $self->{_user});
    return 'The object is missing catalog data'
        unless (my $bdb = $self->{_catalog});

    my $books = $user->wishlist;
    # At this point, @$books is full of keys, not data
    my ($book, @books);
    for (@$books)
    {
        return "ISBN $_ unknown to catalog"
            unless ($book = SoapExBook::get_book($bdb, $_));
        push(@books, { isbn  => $book->{isbn},
                       title => $book->{title},
                       url   => $book->{url} });
    }

    \@books;
}

#
# Add the specified book to the user's wish-list. Returns an
# error if the key/ISBN is unknown to the catalog.
#
sub AddBook {
    my ($self, $isbn) = @_;

    # This is not callable as a static method, so it must
    # have a value user object stored within.
    return 'The object is missing user data'
        unless (my $user = $self->{_user});
    return "ISBN $isbn unknown to catalog"
        unless $user->add_book($isbn);
    $user->write_user;

    $self;
}

#
# Remove a specified book from the wish-list. Note that this
# does NOT return an error if the book was not on the list.
# That case is silently ignored.
#
sub RemoveBook {
    my ($self, $isbn) = @_;

    # This is not callable as a static method, so it must
    # have a value user object stored within.
    return 'The object is missing user data'
        unless (my $user = $self->{_user});
    $user->drop_book($isbn);
    $user->write_user;

    $self;
}

#
# Return a true/false value indicating whether the user is
# approved to purchase books directly off their wish-list.
#
sub CanPurchase {
    my $self = shift;

    # This is not callable as a static method, so it must
    # have a value user object stored within.
    return 'Object is missing user data'
        unless (ref($self) and my $user = $self->{_user});

    $user->can_purchase;
}

#
# Attempt to purchase one or more books on the wish-list.
# The parameter $list contains either a single key, or a
# list-reference of keys.
#
sub PurchaseBooks {
    my ($self, $list) = @_;

    # This is not callable as a static method, so it must
    # have a value user object stored within.
    return 'Object is missing user data'
        unless (ref($self) and my $user = $self->{_user});
    return 'User cannot make direct purchases'
        unless ($user->can_purchase);

    # Handle a single ISBN as just a one-item list
    my @books = ref($list) ? @$list : ($list);

    # Here would normally be lots of convoluted glue code to
    # interact with enterprise systems, CRM, etc. For this
    # example, just remove the books from the wishlist and
    # update the user.
    $user->drop_book($_) for (@books);
    $user->write_user;

    $self;
}

#
# This is the code that is used to generate cookies based on
# the user name and password. It is not cryptographically
# sound, it is just a simple form of obfuscation, used as an
# example.
#
# Courtesy of the Slash codebase
#
sub make_cookie {
    my ($user, $passwd) = @_;
    my $cookie = $user . '::' . md5_hex($passwd);
    $cookie =~ s/(.)/sprintf("%%%02x", ord($1))/ge;
    $cookie =~ s/%/%25/g;
    $cookie;
}
