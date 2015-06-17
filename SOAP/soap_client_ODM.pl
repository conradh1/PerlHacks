#!perl -w
# Filename: soap_client.pl
# Project: Pan-STARRS
# Author: Conrad Holmberg conradh@ifa.hawaii.edu
# This script takes two arguments
# a file for a query and a file to write the output to
# Usage: perl query_DRL.pl -q myquery.txt -r results.txt
###################################################
use strict;
use warnings;
use SOAP::Lite 'trace', 'debug';
use Getopt::Long qw( GetOptions ); #libs for file handles and obtaining command options
use FileHandle;
use DirHandle;
use Data::Dumper;

my $HOST   = 'http://gwen1.pha.jhu.edu/OdmWebservice/OdmWebservice.asmx?wsdl';
my $NS = 'PanSTARRS.Services.OdmWebService';
my $operation = 'Report_catalog';
my $xmlParams = '<AdminQueryParams/>';

my $authSoapService = SOAP::Lite->new( proxy => $HOST,
                                       ns => $NS
                                     );
#misc globals for query
my ($sessionid, $query_file, $output_file, $query);

my $som = $authSoapService->call('Admin',
    SOAP::Data->name('op')->value('Report_catalog'),
    SOAP::Data->name('xmlParams')->value('<AdminQueryParams/>')
 );

# Die if authentication fails
die "SOAP Service Failed: ".$som->faultstring.".\n" if ($som->fault);
my $results = $som->result;

print "$results.\n";

exit(0);
