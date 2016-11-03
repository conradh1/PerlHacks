#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Module Name: dbconnect.pl
# Author: Conrad Holmberg
# Created: June20/00
# Last Modified: March01/01
# This program is for connecting to databases via ODBC
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use DBI; #load DBI module
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);
use Time::localtime; #module for getting the current time and date

# global variables used for database handling
my $cgi= CGI::new(); #used for obtaining information from html pages
my $dbh; #database handle
my $sth; #used for performing queries
my $dsnname = ""; #assigns the name of the database
my $server = "localhost"; #assings the server location
my $port = "";
my $driver = "mysql"; #assigns the driver
my $dsn = "DBI:$driver:$dsnname:$server"; #assigns the destination
my $perl_path= $ENV{'server_name'}.$ENV{'script_name'}; #location of cgi perl program
my $perl_form= $ENV{'HTTP_REFERER'};
my $domain= "http://".$ENV{'server_name'};
# variables used for html user input handling

my $loginname= "";
my $login_password= "";
my $query= "SHOW TABLES";

$| = 1;
# Remove buffering
####################Start Program###########################################
      html_header();
      $dbh = DBI->connect($dsn, $loginname, $login_password);
      die "Error connecting to database: $dsnname\n", $DBI::errstr unless ($dbh);
      
      $sth= $dbh->prepare($query); #prepare db query for executing
      die "Cannot prepare query: $DBI::errstr\n", $DBI::errstr unless($sth);

      $sth->execute;
      die "Cannot execute query: $DBI::errstr\n", $DBI::errstr unless($sth);

      print "<table border=1>";
      my $count= 0;
      while (my @row= $sth->fetchrow()) {
            print"<tr>";
	    $count++;
            foreach (@row) {
            	if (defined($_)) {
                    print "<td> $_ &nbsp;</td>\n"; #print tabledata
               	}
                else {
                    print "<td>&nbsp;</td>\n"; #print empty cell
                }
            }
            print"</tr>";
      }
      print"</table><br><b>$count rows returned.</b>";
      
      $sth->finish; # release the statement handle resources
      die "Cannot finish query: $DBI::errstr\n", $DBI::errstr unless($sth);

      $dbh->disconnect;
      die "Error disconnecting to database $dsnname\n", $DBI::errstr unless ($dbh);

      html_footer();
####################End Program#############################################
############################################################################
############### html header ################################################

sub html_header {
#this subroutine prints the html header
     print header();
     print("<html><head><title>Database Query Execution</title></head>\n",
      "<BODY BGCOLOR='#DDDDDD'>\n",
      "<h1 align= 'center'>Database Connection Test</h1>\n",
      "<a href=\"".$perl_form."\">go back</a>");
} #html_header
############################################################################
################# html footer ##############################################
sub html_footer {
#this subroutine prints the html bottom
	print("<hr></body></html>\n");

} #html_footer

