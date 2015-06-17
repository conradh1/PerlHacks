# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
package SoapExBook;

use 5.005;
use strict;
use subs qw(connect get_book get_books_by_title
            get_books_by_author);

use DB_File;
use Storable qw(freeze thaw);

sub connect {
    my $dbfile = $_[0];

    $dbfile ||
        ($dbfile = __FILE__) =~ s|[^/]+$|catalog.db|;
    my ($tied, %hash);
    return unless ($tied = tie(%hash, 'DB_File', $dbfile));

    $tied;
}

sub get_book {
    my ($db, $key) = @_;

    my $val;
    $key =~ s/-//g;
    return undef if $db->get($key, $val);

    thaw $val;
}

sub get_books_by_title {
    my ($db, $pat) = @_;

    my ($key, $val, @matches);

    return () if ($db->seq($key, $val, R_FIRST));
    do {
        $val = thaw $val;
        push(@matches, $key)
            if (index(lc $val->{title}, lc $pat) != -1);
    } until ($db->seq($key, $val, R_NEXT));

    @matches;
}

sub get_books_by_author {
    my ($db, $pat) = @_;

    my ($key, $val, @matches);

    return () if ($db->seq($key, $val, R_FIRST));
    do {
        $val = thaw $val;
        push(@matches, $key)
            if (index(lc $val->{authors}, lc $pat) != -1);
    } until ($db->seq($key, $val, R_NEXT));

    @matches;
}

1;
