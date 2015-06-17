# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.
package XRFortune;

use 5.6.0;
use strict;
use vars qw($FORTUNE %BOOKS);
use subs qw(books fortune weighted_fortune);

BEGIN {
    # Locate the fortune program. Look in some standard
    # places, then loop over the user's PATH.
    for my $path (qw(/bin /usr/bin /usr/games),
                  split(':', $ENV{PATH})) {
        if (-e "$path/fortune" && -x _) {
            $FORTUNE = "$path/fortune";
            last;
        }
    }
    die "No 'fortune' command found!\n"
        unless $FORTUNE;

    # Calling fortune -f lists the books it knows, but the
    # output goes to STDERR for some reason.
    my @books = qx($FORTUNE -f 2>&1); shift(@books);
    chomp(@books);
    $BOOKS{(reverse split(/ /))[0]}++ for (@books);
}

1;

# If called with no arguments, returns the list of known
# books as a list reference. If one or more book names were
# passed, then take the list and return only the elements
# from it that are known books (pruning operation).
sub books {
    my $list = shift || '';

    my @prune = $list ? (ref $list ? @$list : ($list)) : ();
    my @books;

    if (@prune) {
        @books = sort grep($BOOKS{$_}, @prune);
    } else {
        @books = sort keys %BOOKS;
    }

    \@books;
}

# Get and return one fortune. With no arguments, just call
# the command. With one or more books, limit the selection
# of quotes to those books. When the fortune is extracted,
# take off the OS-dependent newlines and return the lines
# of text as a list reference.
sub fortune {
    my $book = shift || '';

    my @lines;
    my $exec = $FORTUNE;
    my @books = $book ? (ref $book ? @$book : ($book)) : ();
    if (@books) {
        my @bad;
        if (@bad = grep(! $BOOKS{$_}, @books)) {
            local $" = ', ';
            die "fortune: Unknown books (@bad)";
        } else {
            $exec .= " @books";
        }
    }

    chomp(@lines = `$exec`);
    \@lines;
}

# This also retrieves one fortune. However, the arguments
# here are more than just a list of books to restrict the
# search to. If a list reference is passed, use those books
# but weight them all equally in the search. If a hash
# reference is passed, its keys should be books and the
# corresponding values are the integer weights for each
# book. The weights must add up to 100.
sub weighted_fortune {
    my $weights = shift;

    die 'weighted_fortune: Must be called with array of ' .
        "books or struct of weights and books\n"
        unless ref $weights;

    my @lines;
    my $exec = $FORTUNE;
    if (ref($weights) eq 'ARRAY') {
        # Use our own books() call to ensure all the passed
        # books are valid
        $weights = books($weights);
        # The -e flag makes all books equal in weight
        $exec .= " -e @$weights";
    } else {
        # Trickier: must ensure that the weights add up to
        # 100%, even though pruning the list may mean that
        # one or more are dropped.
        my $total_weight;
        my $books = books([ keys %$weights ]);
        $total_weight += $weights->{$_} for (@$books);
        die 'weighted_fortune: Weights must add up to 100' .
            " (total is $total_weight)\n"
            unless ($total_weight == 100);
        $exec .= " $weights->{$_}% $_" for (@$books);
    }

    # As with fortune() above, drop the OS-dependent
    # newline characters and return a list reference.
    chomp(@lines = `$exec`);
    \@lines;
}
