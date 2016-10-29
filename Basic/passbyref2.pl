#/usr/lcl/bin/perl 
#with pointers, assign $ptr= \$str or \%hash or \@array
my $str;

$str = "Hello";

my $ptr = \$str; #pass reference

print "Before sub call string is: $str\n";

subproc($ptr); #call the pointer could also call subproc(\$str)

print "After sub call string is:$str\n";

sub subproc() {
    my $pointer = $_[0]; #assign scalar value to local buffer pointer
    print "Sub call made. Pointer is: $pointer (Should be mem address)\n"; 
    $$pointer = "There";
}

