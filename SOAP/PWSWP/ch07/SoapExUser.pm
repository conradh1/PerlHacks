# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
package SoapExUser;

use 5.005;
use strict;
use vars qw($DBNAME);
use subs qw(import new get_user write_user name wishlist
            can_purchase add_book drop_book dbconnect);

use DB_File;
use Storable qw(freeze thaw);
use SoapExBook;

sub import {
    my ($proto, %args) = @_;

    # Right now, only $args{database} is recognized
    $DBNAME = $args{database} || '';
}

sub new {
    my ($class, @args) = @_;

    my (%hash, $k, $v);
    @hash{qw(name passwd wishlist purchase_ok)} = ('', '', [], 0);
    while (@args)
    {
        ($k, $v) = splice(@args, 0, 2);
        $hash{lc $k} = $v;
    }

    bless \%hash, $class;
}

sub get_user {
    my ($self, $user) = @_;

    my ($db, $val);
    $db = dbconnect;
    return undef if ($db->get($user, $val));
    $val = thaw $val;
    %$self = %$val;

    $self;
}

sub write_user {
    my $self = $_[0];

    return undef unless $self->{name};
    my $db = dbconnect;
    # Pass freeze() a hashref to a COPY of $self, unblessed
    return undef
        if ($db->put($self->{name}, freeze({ %$self })));

    $self;
}

sub name { $_[0]->{name}; }

sub passwd {
    my ($self, $newpass) = @_;

    $self->{passwd} = $newpass if $newpass;
    $self->{passwd};
}

sub wishlist {
    my $list = $_[0]->{wishlist};

    # Return a listref that is a copy, not the main list
    $list ? [ @$list ] : [];
}

sub can_purchase { $_[0]->{purchase_ok}; }

sub add_book {
    my ($self, $book) = @_;

    my $bookdb = SoapExBook::connect;
    return undef unless ($bookdb and
                         SoapExBook::get_book($bookdb, $book));
    $book =~ s/-//g;
    push(@{$self->{wishlist}}, $book);

    $self;
}

sub drop_book {
    my ($self, $book) = @_;

    $book =~ s/-//g;
    @{$self->{wishlist}} =
        grep($_ ne $book, @{$self->{wishlist}});

    $self;
}

sub dbconnect {
    $DBNAME ||
        ($DBNAME = __FILE__) =~ s|[^/]+$|users.db|;
    my %hash;

    tie %hash, 'DB_File', $DBNAME;
}

1;
