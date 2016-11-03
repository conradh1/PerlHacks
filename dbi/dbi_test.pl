#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Module Name: db_test.pl
# Author: Conrad Holmberg
# Created: April 27 - 2006
# This program connects to ORACLE
# test query
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use DBI; #load DBI module
use diagnostics;

my ($hr, $sth, $dbh,);
my %sqls;

####################Start Program###########################################

      # prep static sqls...
      do_sqls();

      print "Making connection...\n";
      mysql_connect();

      do_mysql_query(); 

      mysql_disconnect();

      print "Done";
      exit 0;
####################End Program#############################################
#*******************************************************************************
#************************ do_mysql_query ****************************************
sub do_mysql_query {

  print "Prepare query...\n";

  $sth = $dbh->prepare($sqls{'show_tables'});
  unless ($sth) { die(" ERROR", "Unable to prep sel_auex: $DBI::errstr"); }


  if ($sth->execute) {
      print "Tables:\n";
      while ($hr = $sth->fetchrow()) {
          print "$hr\n";
     } #while
  }
  else {
    die(" ERROR", "Unable to execute sel_emp: $DBI::errstr");
  }
   $sth->finish;
  print "Completed query...\n";
} #do_mysql_query
#******************************************************************************
#******************************************************************************
#************************ coda_connect ****************************************
sub mysql_connect {
# this subroutine connects to the database
  use constant USER    => 'mops';
  use constant BLAH =>  '!m0PS!';
  use constant DRIVER => 'mysql';
  use constant SERVER => 'lsb01.psps.ifa.hawaii.edu';
  use constant DATABASE => 'export';
  my $dsn = 'DBI:'.DRIVER.':'.DATABASE.':'.SERVER;

  $dbh = DBI->connect($dsn, USER, BLAH);

  unless ($dbh) {
    die('Error connecting to database: '.DATABASE." : $DBI::errstr");
  }
} #coda_connect
#******************************************************************************
#************************ coda_disconnect *************************************
sub mysql_disconnect {
# this subroutine disconnects from the database
  if ($sth) { $sth->finish; }
  $dbh->disconnect;
} #coda_disconnect
#******************************************************************************
#************************ do_sqls *********************************************
sub do_sqls {
# create static sqls
  %sqls = (

  "show_tables" =>
             "show tables"
   );
} #do_sqls
