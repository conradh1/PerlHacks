#!/usr/bin/perl -w
# "Programming Web Services with Perl", by Randy J. Ray and Pavel Kulchenko
# O'Reilly and Associates, ISBN 0-596-00206-8.

use strict;
use UDDI::Lite;

my $uddi =
    UDDI::Lite->proxy('http://uddi.microsoft.com/inquire');

for my $letter ('A' .. 'Z') {
    my $results = $uddi->find_business(name => $letter)
                       ->result;
    my @list = $result->businessInfos->businessInfo;
    printf "%c: (%d)\n", $letter, scalar @list;
    printf "\t%s\n", $_->name for (@list);
}

exit;
