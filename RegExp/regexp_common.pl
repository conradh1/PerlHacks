# This script looks for common reg exp patterns such as email, domain name, etc
# and breaks it down.


#!/usr/bin/perl -w
use strict;

my @strings = ( 'bob.nobody@nowhere.com', 'http://nowhere.org', 'http://nowhere.org/?bob=likesmary', '<b>Hyper Text</b>', '@#$bql@#jdk@bal.com'  );


foreach my $str ( @strings ) {

  print "Looking for pattern with: $str \n";

  if ( $str =~ /^([\d\w\W\.]+)\@([\d\w\W\.]+)$/g ) {
    print "Found Email: username: $1 domain: $2\n";
  }
  elsif ( $str =~ /^([\w.]+)\:\/\/([\d\w\.]+)\/?(.*)$/ ) {
    print "Found Domain: protocol: $1 domain: $2 path: $3\n";
  }
  elsif ( $str =~ /\<([\w\W]+)\>([^<]+)\<\/([\w\W]+)\>/ ) {
    print "Found UML: start tag: $1 content: $2 end tag $3\n";
  }
  else {
    print "No pattern\n";
  }

}
exit 0;

