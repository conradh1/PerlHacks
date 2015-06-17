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
use QueuedJobsServiceService;

#libs for file handles and obtaining command options
use Getopt::Long qw( GetOptions );
use FileHandle;
use DirHandle;

#globals
my ($query_file, $output_file, $query);

# These are instances of the SOAP Services from the 
# SOAP Lite generated code
my $authService = new AuthServiceService;
my $queuedJobService = new QueuedJobsServiceService;

# Get the file with the query and the file to write
# the results to.
GetOptions ("query=s" => \$query_file,
            "results=s" => \$output_file
           );

#make sure that we have a input and output file
if ( ! ( $query_file || $output_file )) {
  die ( "Error, bad usage..\nUsage:perl query_DRL.pl [-query|-q] filename [-results|-r] resultset\n".
        "Example: perl query_DRL.pl -q myquery.txt -r results.txt " );
}

#hard coded variables needed to use the DRL service
my $userid = "psps_tester";  #This user must be located both on the DRL and CasJobs
my $password = "!psps!";
my $schemaGroup = "MOPS"; # Name of the database instance (ie PS1, MOPS )
my $schema = "MOPS";  # Name of the database instance ( mydb, mops_test, myps1, etc )


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

get_query(); #assign the query file to a string

print "Executing Query...\n";
open RESULTSET, ">$output_file" or die "Couldn't open file: $!"; #open for write, overwrite
#Make the SOAP call for the query and print the output to a file
if ( print RESULTSET $queuedJobService -> submitQuery( $sessionID, $schemaGroup, $schema, $query ) ) {
  print "Query Complete, results in $output_file\n";
}
#print $queuedJobService->result();
close RESULTSET;

print "Done!\n";

exit(0);

#######################################################################
# Assigns the entire query file to a string
sub get_query() {
  print "Examining Query...\n";
  local $/=undef; #Unset $/, the Input Record Separator, to make <> give you the whole file at once. 
  open QUERYFILE, $query_file or die "Couldn't open file: $!";
  binmode QUERYFILE;
  $query = <QUERYFILE>;
  close QUERYFILE;
} #get_query
#######################################################################



 
