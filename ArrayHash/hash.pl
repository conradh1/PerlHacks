#!/usr/bin/perl --

my %FIELDS;

my $page;
my $fieldcnt;
my $i;
        
for ($page = 0; $page < 5; $page++) {
        for ($fieldcnt = 0; $fieldcnt < 7; $fieldcnt++) {
                push(@{$FIELDS{"x".$page}}, "IN_".$page."_".$fieldcnt);
        }       
        for $i (@{$FIELDS{"x".$page}}) {
                print "page: $page: array: $i\n";
        }
}

foreach $keyx (keys %FIELDS) {
        for $i (@{$FIELDS{$keyx}}) {
                print "key = $keyx value = $i\n";
        }
}



