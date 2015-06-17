#!perl -w
# Filename: PSPS_query.pl
# Project: Pan-STARRS
# Author: Conrad Holmberg conradh@ifa.hawaii.edu
# This script takes two arguments
# a file for a query and a file to write the output to
# Usage: perl query_DRL.pl -q myquery.txt -r results.txt
###################################################
use strict;
use warnings;
use SOAP::Lite;
use Getopt::Long qw( GetOptions ); #libs for file handles and obtaining command options
use FileHandle;
use DirHandle;
use Data::Dumper;

my $AuthHOST   = 'http://ambon.ifa.hawaii.edu:8080/Mleadr/AuthService';
my $QueryHOST = 'http://ambon.ifa.hawaii.edu:8080/Mleadr/QueuedJobsService';
my $NS = 'http://services.ws.mleadr.referentia.com/';

my $authSoapService = SOAP::Lite->new( proxy => $AuthHOST,
                            ns => $NS
                          );
                          
my $querySoapService = SOAP::Lite->new( proxy => $QueryHOST,
                            ns => $NS
                          );

#misc globals for query
my ($sessionid, $query_file, $output_file, $query);

my $userid = "psps_tester";  #This user must be located both on the DRL and CasJobs
my $password = "!psps!";
my $schemaGroup = "MOPS"; # Name of the database instance (ie PS1, MOPS )
my $schema = "MOPS";  # Name of the database instance ( mydb, mops_test, myps1, etc )

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

my $som = $authSoapService->call('login',
    SOAP::Data->name('userid')->value($userid),
    SOAP::Data->name('password')->value($password)
 );

# Die if authentication fails
die "Failed to authenticate. Check user/password or check that AuthService sevice is running: ".$som->faultstring.".\n" if ($som->fault);
my $sessionID = $som->result;

print "Authentication successful! Token: $sessionID.\n";

read_query(); #assign the query file to a string

print "Attempting to execute Query...\n";
#Make the SOAP call for the query and print the output to a file

$som = $querySoapService->call('submitQuery',
    SOAP::Data->name('sessionID')->value($sessionID),
    SOAP::Data->name('schemaGroup')->value($schemaGroup),
    SOAP::Data->name('schema')->value($schema),
    SOAP::Data->name('query')->value($query)
 );

die "ERROR, Query failed: ".$som->faultstring.".\n" if ($som->fault);
my $results = $som->result;
if ( $results ) {
  write_results( $results );
}
else {
  print "No results returned.\n";
}

#print Dumper( $queuedJobService );

exit(0);

#######################################################################
# Assigns the entire query file to a string
sub read_query {
  print "Examining Query...\n";
  local $/=undef; #Unset $/, the Input Record Separator, to make <> give you the whole file at once. 
  open QUERYFILE, $query_file or die "Couldn't open file: $!";
  binmode QUERYFILE;
  $query = <QUERYFILE>;
  close QUERYFILE;
} #read_query
#######################################################################
# Write Query results to a file
sub write_results {
  my ($results) = @_;
  open RESULTSET, ">$output_file" or die "Couldn't open file: $!"; #open for write, overwrite
  print RESULTSET $results;
  print "Query Complete, results in $output_file\n";
  close RESULTSET;
  print "Sucess!\n";
}
#######################################################################