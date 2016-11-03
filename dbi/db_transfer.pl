#!/usr/bin/perl -w
##################################
# Perl Script Version 5.0
# Module Name: db_transfer.pl
# Author: Conrad Holmberg
# Created: 05/21/02
# Last Modified: 10/16/03
# This program connects to two databases
# and selects info from one and
# inserts it into another
##################################

# imported Perl Modules
use strict; #use strict protocol rules
use DBI; #load DBI module
use diagnostics;
use Time::localtime; #module for getting the current time and date

# global variables used for database handling
my $dbh1; #database handle
my $dbh2;

my $sth1; 
my $sth2;

my $dsnname1= "linkdb"; #assigns the name of the source database
my $dsnname2= "linkagentdb"; #receiving database and so on below

my $server1= "localhost"; 
my $server2= "localhost"; 

my $port1= "";
my $port2= "";

my $driver1= "mysql"; 
my $driver2= "mysql"; 

my $dsn1 = "DBI:$driver1:$dsnname1:$server1"; 
my $dsn2 = "DBI:$driver2:$dsnname2:$server2"; 

my $loginname1= "tech";
my $login_password1= "tecH1n";
my $loginname2= "tech";
my $login_password2= "tecH1n";

my @datalist; #2D array for storing tables.
my $query= "SELECT a.number, a.url, a.title, a.accessed, a.description ".
	"FROM link a, courselink b ".
	"WHERE a.number= b.url_number AND ".
	"b.courseID IS NOT NULL ORDER BY a.number";
#$query= "SELECT courseID, name FROM course ORDER BY courseID";
#$query= "SELECT courseID, url_number FROM courselink ORDER BY courseID";
####################Start Program###########################################

#gets data and inserts data from several tables
getDBInfo($query);
#insertDBInfo();
print("Done!\n");
exit();
####################End Program#############################################
#################### getDBInfo #############################################
sub getDBInfo {
#retrieves data in a single table from the source database
	my ($query)= @_;
	$dbh1= DBI->connect($dsn1, $loginname1, $login_password1);
	die "Error connecting to database: $dsnname1\n", $DBI::errstr unless ($dbh1);
	
	$sth1= $dbh1->prepare($query); 
	die "Cannot prepare query: $DBI::errstr\n", $DBI::errstr unless($sth1);
	
	$sth1->execute;
	die "Cannot execute query: $DBI::errstr\n", $DBI::errstr unless($sth1);
	
	my $i= 0;
	while (my @row= $sth1->fetchrow()) {
		foreach (@row) {
			$_=~ s/"/\"/gi #add escape characters to single quote;
		}
		push(@datalist, [@row]);
	}
	$sth1->finish; # release the statement handle resources
	die "Cannot finish query: $DBI::errstr\n", $DBI::errstr unless($sth1);

	$dbh1->disconnect;
	die "Error disconnecting to database $dsnname1\n", $DBI::errstr unless ($dbh1);
}
#################### insertDBInfo ###########################################
sub insertDBInfo {
#retrives data from source database in array and inserts into receiving database.
	my $insert_query= "";
	$dbh2= DBI->connect($dsn2, $loginname2, $login_password2);
	die "Error connecting to database: $dsnname2\n", $DBI::errstr unless ($dbh2);
	
	for my $i ( 0 .. $#datalist ) {
		$insert_query= "INSERT INTO Links ".
			"(pk_LinkID, URL, Title, Last_accessed, Description, Status) ".
			"VALUES (\"$datalist[$i][0]\",\"$datalist[$i][1]\",\"$datalist[$i][2]\",".
			"\"$datalist[$i][3]\",\"$datalist[$i][4]\",\"Active\")";
		#for my $j ( 0 .. $#{$datalist[$i]} ) {
			#print "$datalist[$i][$j]|";
		#}
		#print($query."\n");
		#$insert_query= "INSERT INTO Courses ".
			#"(pk_CourseID, Name) ".
			#"VALUES (\"$datalist[$i][0]\",\"$datalist[$i][1]\")";
		
		#$insert_query= "INSERT INTO CourseLinks ".
			#"(fk_CourseLinks_CourseID,fk_CourseLinks_LinkID) ".
			#"VALUES (\"$datalist[$i][0]\",\"$datalist[$i][1]\")";
		$sth2= $dbh2->prepare($insert_query); 
		die "Cannot prepare query: $DBI::errstr\n", $DBI::errstr unless($sth2);
	
		$sth2->execute;
		die "Cannot execute query: $DBI::errstr\n", $DBI::errstr unless($sth2);
	}
	
	
	$sth2->finish; # release the statement handle resources
	die "Cannot finish query: $DBI::errstr\n", $DBI::errstr unless($sth2);

	$dbh2->disconnect;
	die "Error disconnecting to database $dsnname2\n", $DBI::errstr unless ($dbh2);
}
#################################################################################
