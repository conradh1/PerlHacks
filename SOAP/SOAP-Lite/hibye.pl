#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite 'trace', 'debug';

# print SOAP::Lite                                             
#   -> uri('http://ambon.ifa.hawaii.edu/cgi-bin/Demo')
#   -> proxy('http://ambon.ifa.hawaii.edu/cgi-bin/hibye.cgi')
#   -> on_action(sub{sprintf "%s/%s",@_})
#   -> hi()                                                    
#   -> result;

my $soap = SOAP::Lite
          -> uri('http://ambon.ifa.hawaii.edu/cgi-bin/Demo')
          -> on_action( sub { join '/', 'http://ambon.ifa.hawaii.edu/cgi-bin/Demo', $_[1] } )
          -> proxy('http://ambon.ifa.hawaii.edu/cgi-bin/hibye.cgi');

my $returned = $soap ->call(SOAP::Data->name('hi')); 
print $returned->result;
print "\n";
