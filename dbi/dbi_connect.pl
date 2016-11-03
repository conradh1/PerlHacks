#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Module Name: dbconnect.pl
# Author: Conrad Holmberg
# Created: June20/00
# Last Modified: March01/01
# This program is for connecting to databases via ODBC/MySQL
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use DBI; #load DBI module
use diagnostics;

# global variables used for database handling
my $dbh; #database handle
my $sth; #used for performing queries
#my $dsnname = "psmops_run3S_20090818"; #assigns the name of the database
my $dsnname = "dxlayer"; #assigns the name of the database
my $server = "ps01.pha.jhu.edu"; #assings the server location
my $port = "";
my $driver = "Pg"; #assigns the driver
my $dsn = "dbi:$driver:dbname=$dsnname;host=$server"; #assigns the destination
# variables used for html user input handling
my $loginname= "conradh";
my $login_password= "pstrs100";

$| = 1;
# Remove buffering
####################Start Program###########################################
     # $dbh = DBI->connect("dbi:Pg:dbname=$dbname", '', '', {AutoCommit => 0});

      if ($dbh = DBI->connect($dsn, $loginname, $login_password)) {
        print("Connection test successful!\n");
      }
      else  {
        print("Connection test failed.");
        die "Error connecting to database: $dsnname\n", $DBI::errstr unless ($dbh);
      }
      
      $sth= $dbh->prepare("show tables"); #prepare db query for executing
      die "Cannot prepare query: $DBI::errstr\n", $DBI::errstr unless($sth);

      $sth->execute;
      die "Cannot execute query: $DBI::errstr\n", $DBI::errstr unless($sth);

      while (my @row= $sth->fetchrow()) {
            foreach (@row) {
            	if (defined($_)) {
                    print "$_ \n"; #print tabledata
               	}
            }
      }
      $sth->finish; # release the statement handle resources
      die "Cannot finish query: $DBI::errstr\n", $DBI::errstr unless($sth);

      $dbh->disconnect;
      die "Error disconnecting to database $dsnname\n", $DBI::errstr unless ($dbh);

####################End Program#############################################

