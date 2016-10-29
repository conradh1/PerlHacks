#!/usr/bin/env perl
#
# Data Store product  create and delete
#

use strict;
use warnings;

use Getopt::Long qw( GetOptions );


my $url = '';
my $fileset = '';
my $new = '';
my $count = '';
my $number = '';
my $filename = '';
my $download = '';


GetOptions ("url=s" => \$url,
            "fileset=s" => \$fileset,
            "new" => \$new,
            "count" => \$count);



print("Options are:\n url = |$url|\n fileset = |$fileset|\n new = |$new| count |$count|\n");
