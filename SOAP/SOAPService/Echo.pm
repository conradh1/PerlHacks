#!/usr/bin/perl
# Filename: Echo.pm
# Echo Web Service Perl Module - This module is where requests to the
# Echo Web service will be dispatched.
# Author: Byrne Reese
package Echo;
use strict;
sub echo {
my ($self,@args) = @_;
return join(",",@args);
}
1;