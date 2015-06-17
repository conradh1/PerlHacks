#/usr/lcl/bin/perl 

my $lcl;

$lcl = 5;

my $pointer = \$lcl;

if ($lcl == $$pointer) {
        print "true\n";
}

subproc(\$lcl);

print "after:$lcl:\n";

sub subproc() {

my $pointer = $_[0];
if ($$pointer == 5) {
        print "sub true\n";
        print "before:$$pointer:\n";
        $$pointer = 6;
} 

else {
        print "sub false\n";
        print ":$$pointer:\n";
    }
}

