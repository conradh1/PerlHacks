#!/usr/bin/perl -w
# Perl Script Version 5.0
# Program Name: LSO.pl
# Author: Conrad Holmberg
# Created: May 25/99
# This program creates tables from a database 
# to the preference of the user

use strict;
use DBI;
use CGI qw/:standard :cgi/;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);

$| = 1;
# Remove buffering
 
my $query;
# Used for mysql queries

my $dbh; 
my $sth;
# globals used for connecting to database

my %view = ( 
	 "view_1" => "courseid, day_of_week, contract_start_date, contract_end_date, instructor, delivery_mode, delivery_comments, notes, cancelled, institution, contact, contact_phone, contact_email, central_office",
	 "view_2" => "courseid, institution, contact, contact_phone, day_of_week, contract_start_date, contract_end_date, instructor, delivery_mode, delivery_comments, notes, cancelled", 

         "view_3" => "courseid, instructor, id_instructor, enrollments, crs_pkg_reserve, day_of_week, contract_start_date, contract_end_date, delivery_mode, delivery_comments, notes, cancelled, id_semester, institution, contact, contact_phone, contact_email, central_office, projectid",
	 "view_4" => "courseid, institution, projectid, enrollments, day_of_week, contract_start_date, contract_end_date, crs_pkg_reserve, last_updated",
         "view_5" => "supervisor, courseid, institution, enrollments, id_semester",
	 );
# assigns different view to a hash

my %columns = (
	 "projectid" => "<TH><FONT SIZE=-1>Project (#ID)</FONT></TH>",
	 "institution" => "<TH><FONT SIZE=-1>Institution</FONT></TH>",
	 "program" => "<TH><FONT SIZE=-1>Program</FONT></TH>",
	 "supervisor" => "<TH><FONT SIZE=-1>Supervisor</FONT></TH>",
	 "courseid" => "<TH><FONT SIZE=-1>Course (#ID)</FONT></TH>",
	 "enrollments" => "<TH><FONT SIZE=-1>Enrollments</FONT></TH>",
	 "crs_pkg_reserve" => "<TH><FONT SIZE=-1>Course Package Reserve</FONT></TH>",   
	 "contract_start_date" => "<TH><FONT SIZE=-1>Contract Dates</FONT></TH>",
	 #"contract_end_date" => "<TH><FONT SIZE=-1>Contract End Date</FONT></TH>",
	 #"day_of_week" =>  "<TH><FONT SIZE=-1>Day of Week</FONT></TH>",
	 "instructor" => "<TH><FONT SIZE=-1>Instructor</FONT></TH>",
	 "id_instructor" => "<TH><FONT SIZE=-1>Instructor (#ID)</FONT></TH>",
	 "id_semester" => "<TH><FONT SIZE=-1>Semester (#ID)</FONT></TH>",
	 "delivery_mode" => "<TH><FONT SIZE=-1>Delivery</FONT></TH>",
	 #"delivery_comments" => "<TH><FONT SIZE=-1>Delivery Comments</FONT></TH>",
	 "notes" => "<TH><FONT SIZE=-1>Notes</FONT></TH>",
	 "cancelled" => "<TH><FONT SIZE=-1>Cancelled</FONT></TH>",
	 "last_updated" => "<TH><FONT SIZE=-1>Last Updated</FONT></TH>",
	 #columns from the LSOcourses table

	 "institution_code" => "<TH><FONT SIZE=-1>Institution Code</FONT></TH>",
	 "institution_name" => "<TH><FONT SIZE=-1>Instutution Name</FONT></TH>",
	 "central_office" => "<TH><FONT SIZE=-1>Central Office</FONT></TH>",
	 "contact" => "<TH><FONT SIZE=-1>Contact</FONT></TH>",
	 #"contact_phone" => "<TH><FONT SIZE=-1>Contact Phone</FONT></TH>",
	 "contact_email" => "<TH><FONT SIZE=-1>Contact Email</FONT></TH>",
	 "student_contact" => "<TH><FONT SIZE=-1>Student Contact</FONT></TH>",
	 "student_phone" => "<TH><FONT SIZE=-1>Student Phone</FONT></TH>",
	 "student_email" => "<TH><FONT SIZE=-1>Student Email</FONT></TH>",
	 "opening_day" => "<TH><FONT SIZE=-1>Opening Day</FONT></TH>",
	 "site_location_1" => "<TH><FONT SIZE=-1>Location Sites</FONT></TH>",
	 "site_code_1" => "<TH><FONT SIZE=-1>First Site Code</FONT></TH>",
	 #"site_location_2" => "<TH><FONT SIZE=-1>Second Location Sites</FONT></TH>",
	 "site_code_2" => "<TH><FONT SIZE=-1>Second Site Code</FONT></TH>",
	 #columns from the LSOinstitutes table
);
# assigns the different column headers to a hash

print header();
#cgi to start html view 

my $season = param("view_semester");
#get the season from the html form

my $value_view = param("view_form");
#gets the view value from the html form

#################Start Program###################

if ($value_view eq 'view_1') {
    view1();
}
elsif ($value_view eq 'view_2') {
    view2();
}
elsif ($value_view eq 'view_3') {
    view3();
}
elsif ($value_view eq 'view_4') {
    view4();
}
elsif ($value_view eq 'view_5') {
    view5();
}
else {
    print"Error.  No view type selected.";
}

disconnectdb();
#disconnects from the database

#################End Program###################

sub connectdb {
# this subroutine connects to the database

    my $dbname = "LSO";
    # assigns the name of the database

    my $server = "localhost";

    my $port = "";
 
    my $username = "denisem";
    # assigns a user to the working db

    my $password = "lsoosl";
    # assigns the password to the working db

    my $driver = "mysql";
    # assigns the driver
 
    my $dsn = "DBI:$driver:$dbname";
    # assigns the destination

    $dbh = DBI->connect($dsn, $username, $password);
    #attempt to connect to an existing db

    die "Error connecting to database: $dbname\n", $DBI::errstr unless ($dbh);
    #prints out error is attempt to conect to db failed

    $sth = $dbh->prepare("$query");
    #prepares the query from the view type
    if (!defined $sth) {
	die  "Cannot prepare statement: $DBI::errstr\n";
    }
    
    $sth->execute;
    #Execute the statement at the database level
}

sub disconnectdb {
#this subroutine disconnects from the database

    $sth->finish; 
    # Release the statement handle resources

    $dbh->disconnect;
    # Disconnect from the database
}

sub view1 {
#this sub-routine prints out a table if the variable view_form equals view_1 in LSO_web.html
    
   print"<html><head><title>Paced Course Offerings</title></head>\n";
   print"<body background='/images/bkgrd3.gif'><center><h1>Paced Course Offerings by Institution/Collaboration</h1><p>";
   print"Note: All courses are subject to approval and availability<p><hr>";
   # creates the html title and table

   $query= "SELECT $view{$value_view} FROM LSOcourses, LSOinstitutes WHERE institution = institution_name AND internet_only != 'Y' AND id_semester LIKE '$season%' ORDER BY institution, courseid, contract_start_date";
   # designs the query to be viewed

   connectdb($query);
   # connects to the database and executes the query

   my @cols = split(', ', $view{$value_view});
   # splits the hash view used for individual columns
    
   # pops off the columns used for table titles
   for (my $count = 0; $count < 5; $count++) {
	pop(@cols);
    }
    
   my $temp_institute = "nothing";
   # variable used for comparison of different header values for table titles

   my @row;
   # variable used for fetching data rows

   print"<table width= 100% border = 5%>";
   
   while (@row = $sth->fetchrow()) {

       if ($temp_institute ne $row[9]) {
	   # sub-routine prints the table titles
	   table_titles(6, 9, @row);
	   foreach (@cols) {
	       print"$columns{$_}";
	   }
          $temp_institute = $row[9];
        }   
	
       #print entire row
       print "<tr>".
	    "<td>$row[0]&nbsp</td>".
		"<td>$row[1]&nbsp<p>".
		    "Start Date: $row[2]&nbsp<p>".
			"End Date: $row[3]&nbsp</td>".
			    "<td>$row[4]&nbsp</td>".
				"<td>$row[5]&nbsp<p>".
				    "$row[6]&nbsp</td>".
					"<td>$row[7]&nbsp</td>".
					    "<td>$row[8]&nbsp</td>".
						"</tr>";
    }

    print "</table></html>";
    #end of html table
}

sub view2 {
#this sub-routine prints out a table if the variable view_form equals view_2 from LSO_web.html

   print"<html><head><title>AU- LSO Paced Course Information</title></head>\n";
   print"<body background='/images/bkgrd3.gif'><center><h1>Paced Course Offerings by Course</h1><p>";
   print"Note: All courses are subject to approval and availability<p></center><hr>";
   # creates the html title and table

   $query= "SELECT $view{$value_view} FROM LSOcourses LEFT JOIN LSOinstitutes ON institution = institution_name WHERE internet_only != 'Y' AND id_semester LIKE '$season%' ORDER BY institution, projectid, courseid"; 
   # designs the query to be viewed
 
   connectdb($query);
   # connects to the database and executes the query

   my @cols = split(', ', $view{$value_view});
   # splits the hash view used for individual columns

   my @row;
   # variable used for fetching data rows

   print"<table width= 100% border = 5%>";
   
   foreach my $item(@cols) {
       print"$columns{$item}";
   }
   
   while (@row = $sth->fetchrow()) {
       
       my $phone = $row[3];
       
       if (defined($phone)) {
	   substr($phone, 0, 0) = "(";
	   substr($phone, 4, 0) = ") ";
	   substr($phone, 9, 0) = "-";
	   $phone = "Phone: $phone&nbsp";
       }
       
              
       #prints entire row       
       print "<tr>",
	   "<td> $row[0]&nbsp</td>",
	       "<td> $row[1]&nbsp</td>",
		   "<td width = 30%>Contact: $row[2]&nbsp<p>",
		       "$phone</td>",
			   "<td> $row[4]&nbsp<p>",
			       "Start Date: $row[5]&nbsp<p>",
				   "End Date: $row[6]&nbsp</td>",
				       "<td> $row[7]&nbsp</td>",
					   "<td> $row[8]&nbsp<p>",
					       "$row[9]&nbsp</td>",
						   "<td> $row[10]&nbsp</td>",
						       "<td> $row[11]&nbsp</td>",
							   "</tr>";
       
   }
   print "</table></html>";
   #end of html table
}

sub view3 {
# this sub-routine prints out a table if the variable view_form equals view_3 from LSO_intranet.html

   print"<html><head><title>AU- Table of LSO courses from LSO Database</title></head>\n";
   print"<body background='/images/bkgrd3.gif'><center><h1>LSO- Paced Course Information</h1><p>";
   print"<h2>Sorted by Project</h2><hr><p>";
   print "Note: All courses are subject to approval and availability</center><hr>";
   # creates the html title and table

   $query= "SELECT $view{$value_view} FROM LSOcourses LEFT JOIN LSOinstitutes ON institution = institution_name WHERE id_semester LIKE '$season%' ORDER BY institution, projectid, courseid"; 
   # designs the query to be viewed

   connectdb($query);
   # connects to the database

   # rids the commas in the view hash
   my @cols = split(', ', $view{$value_view});
    
   # pops off the table titles
   for (my $count = 0; $count < 7; $count++) {
	pop(@cols);
    }
   
   my $temp_institute = "nothing";
   # variable used for comparison of different header values for table titles
   
   my $temp_project = "nothing"; 
   # variable  used for comparison of different project ids
   
   my @row;
   # variable used for fetching data rows
  
   print"<table width= 100% border = 5%>";
   
   while (@row = $sth->fetchrow()) {
	
       if ($temp_institute ne $row[13]) {
	   
           #routine to create table titles 
	   table_titles(8, 13, @row);
	   $temp_project= $row[18];
	   print "<tr><th align= left colspan = 8>Project ID: $row[18]</th></tr>";
	   foreach (@cols) {
	       if ($_ eq 'id_instructor') { 
	       #do nothing
	       }
               else {
                print"$columns{$_}";
              }
	   }
	   $temp_institute = $row[13];
       }   

       if ($temp_project ne $row[18]) {
	   print "<tr><th align= left colspan = 8>Project ID: $row[18]</th></tr>";
	   $temp_project= $row[18];
       }
 
       my $instructor= $row[1];
       my $instructor_id= $row[2];

       if ($instructor) {
	    $instructor= "Name: $row[1] &nbsp";
       }
       if ($instructor_id) {
	   $instructor_id=  "#ID: $row[2] &nbsp";
       }
       print "<tr>",
	  "<td> $row[0] &nbsp</td>",
	      "<td>$instructor &nbsp <p>",
		 "$instructor_id &nbsp </td>",
		     "<td> $row[3] &nbsp</td>",
			 "<td> $row[4] &nbsp</td>",
			     "<td> $row[5] &nbsp <p>",
				 "Start Date: $row[6] &nbsp <p>",
				     "End Date: $row[7] &nbsp </td>",
					 "<td> $row[8] &nbsp <p>",
					     "$row[9] &nbsp </td>",
						 "<td> $row[10] &nbsp</td>",
						     "<td> $row[11] &nbsp</td>",
							 "</tr>";
   }
   print "</table></html>";
   #end of html table  
}

sub view4 {
# this sub-routine prints out a table if the variable view_form equals view_4 from LSO_intranet.html

   print"<html><head><title>AU- Table of LSO courses from LSO Database</title></head>\n";
   print"<body background='/images/bkgrd3.gif'><center><h1>LSO- Paced Course Information</h1><p>";
   print"<h2>Sorted By Course</h2><hr><p>";
   print "Note: All courses are subject to approval and availability</center><hr>";
   # creates the html title

   $query= "SELECT $view{$value_view} FROM LSOcourses WHERE id_semester LIKE '$season%' ORDER BY courseid, institution";
   connectdb($query);
   # designs the query to be viewed

   my @cols = split(', ', $view{$value_view});
   # splits the hashs view used for individual columns
   my @row;
   # variable used for fetching data rows

   print"<table width= 100% border = 5%>";
   
   foreach my $item(@cols) {
       print"$columns{$item}";
   }
 
   while (@row = $sth->fetchrow()) {
	
       my $temp_lastupdated= $row[8];
       if ($temp_lastupdated) {
	    substr($temp_lastupdated, 4, 0) = "-"; 
	    substr($temp_lastupdated, 7, 0) = "-";
	    substr($temp_lastupdated, 10, 0) = "-";
	    substr($temp_lastupdated, 13, 0)= ":";
	    substr($temp_lastupdated, 16, 0)= ":";
	}
       
       #prints entire row
        print "<tr>",
	    "<td>$row[0]&nbsp</td>",
		 "<td>$row[1]&nbsp</td>",
		      "<td>$row[2]&nbsp</td>",
			   "<td>$row[3]&nbsp</td>",
			       "<td>$row[4]&nbsp <p>",
				   "Start Date: $row[5]&nbsp<p>",
				       "End Date: $row[6]&nbsp</td>",
					   "<td>$row[7]&nbsp</td>",
					       "<td>$temp_lastupdated&nbsp</td>",
						   "</tr>";
    }
    
   print "</table></html>";
    
}

sub view5 {
# this sub-routine prints out a table if the variable view_form equals view_5 from LSO_intranet.html

   my ($supervisor, $courseid, $institution, $enrollments, $id_semester);
   
   print"<html><head><title>LSO Paced Course Offerings</title></head>\n";
   print"<body background='/images/bkgrd3.gif'><center><h1>Athabasca University Table of LSO Courses\n</h1><p>";
   print"<h2>Sorted by Supervisor</h2><hr><p>";
   print "Note: All courses are subject to approval and availability</center><hr>";
   # creates the html title 

   $query= "SELECT $view{$value_view} FROM LSOcourses WHERE id_semester LIKE '$season%' ORDER BY supervisor";
   
   connectdb($query);
   # designs the query to be viewed

   my @cols = split(', ', $view{$value_view});
   # splits the hash view used for individual columns

   my @row;
   # variable used for fetching data rows

   print"<table width= 100% border = 5%>";
   
   foreach (@cols) {
       print"$columns{$_}";
   }
   
   $sth->bind_columns(undef, \$supervisor, \$courseid, \$institution, \$enrollments, \$id_semester);
 
   while (@row = $sth->fetchrow()) {
	
        print "<tr>";
        print "<td>$supervisor&nbsp</td>";
	print "<td>$courseid&nbsp</td>";
	print "<td>$institution&nbsp</td>";
	print "<td>$enrollments&nbsp</td>";
	print "<td>$id_semester&nbsp</td>";
	print"</tr>";
    }
    
   print "</table></html>";
   # end of html table 
}

sub table_titles {
# this subroutine accepts the column span of the table, the starting index of the title 
#in the array, and the data row
  
    my ($col_size, $start_pos, @row)= @_;
    
    my $institute= $row[$start_pos];
    my $contact= $row[++$start_pos];
    my $phone= $row[++$start_pos];
    my $email= $row[++$start_pos];
    my $office= $row[++$start_pos];

    #checks whether contact information is null
    if (defined($contact)) {
	$contact= "<font size = 4><b>Contact: </b>$contact &nbsp&nbsp";
    }
  
    if (defined($phone)) {
	#adds brackets to the phone number
	substr($phone, 0, 0) = "(";
	substr($phone, 4, 0) = ") ";
	substr($phone, 9, 0) = "-";
	$phone= "<b>Phone: </b>$phone &nbsp&nbsp";
    }
    
    if (defined($email)) {
	$email= "<b>Email: </b>$email &nbsp&nbsp";
    }
    
    if (defined($office)) {
	$office= "<b>Address: </b>$office &nbsp&nbsp";
    }
	
    print "<tr>",
	"<td colspan= $col_size>&nbsp&nbsp<br><font size = 5><center><b>Institution: $institute</b></font><br>&nbsp<br>",
	    "$contact",
		"$phone",
		    "$email",
			"$office",
			     "<br>&nbsp</td></tr>";
	    
}    

#end of LSO.pl
