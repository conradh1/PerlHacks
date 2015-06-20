#!/usr/bin/perl

# query_DRL.pl
#
# Perl Script Version v5.10.0
# Author: Conrad Holmberg
# Created: June 1, 2009
# 
# This script takes two arguments
# a file for a query and a file to write the output to
# example: perl query_DRL.pl -q myquery.txt -r results.txt
#
#


#import generated Perl Modules for accessing wsdl SOAP Services
use AuthServiceService;

#libs for file handles and obtaining command options
use Getopt::Long qw( GetOptions );
use FileHandle;
use DirHandle;
use Data::Dumper;

#globals
my ($query_file, $output_file, $query);

# These are instances of the SOAP Services from the 
# SOAP Lite generated code
my $authService = new AuthServiceService;

#hard coded variables needed to use the DRL service
my $userid = "";  #This user must be located both on the DRL and CasJobs
my $password = "";


#first we have to authenticate with the DRL and retrive a token
print "Authenticated...\n";
my $sessionID = $authService -> login( $userid, $password ); 

# Check for token
if ( $sessionID ) {
  print "Session ID is |$sessionID|, Logged in as $userid \n";
}
else {
  die ("Failed to authenticate. Check user/password or do a debug trace for details within the AuthService module.");
}

exit(0);




 
