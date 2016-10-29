#!/usr/bin/perl
##############################################################################
# WWWBoard                      Version 2.0 ALPHA 2                          #
# Copyright 1996 Matt Wright    mattw@worldwidemart.com                      #
# Created 10/21/95              Last Modified 11/25/95                       #
# Scripts Archive at:           http://www.worldwidemart.com/scripts/        #
##############################################################################
# COPYRIGHT NOTICE                                                           #
# Copyright 1996 Matthew M. Wright  All Rights Reserved.                     #
#                                                                            #
# WWWBoard may be used and modified free of charge by anyone so long as      #
# this copyright notice and the comments above remain intact.  By using this #
# code you agree to indemnify Matthew M. Wright from any liability that      #  
# might arise from it's use.                                                 #  
#                                                                            #
# Selling the code for this program without prior written consent is         #
# expressly forbidden.  In other words, please ask first before you try and  #
# make money off of my program.                                              #
#                                                                            #
# Obtain permission before redistributing this software over the Internet or #
# in any other medium.  In all cases copyright and header must remain intact.#
##############################################################################

# Define Variables
$basedir = "/usr/local/apache/htdocs/html/server/wwwboard/" . $ENV{'QUERY_STRING'};
$baseurl = "http://wren.cs.athabascau.ca/html/server/wwwboard/" . $ENV{'QUERY_STRING'};
$cgi_url = "http://wren.cs.athabascau.ca/cgi-bin/wwwboard.pl?" . $ENV{'QUERY_STRING'};

$mesgdir = "messages";
$datafile = "data.txt";
$mesgfile = "index.htm";
$hlpfile = "help.htm";

$ext = "htm";

$title = "Message Index";

# Done
###########################################################################

###########################################################################
# Configure Options

$show_hlp = 0;		# 1 - YES; 0 = NO
$allow_html = 1;	# 1 = YES; 0 = NO
$quote_text = 0;	# 1 = YES; 0 = NO
$subject_line = 0;	# 0 = Quote Subject Editable; 1 = Quote Subject 
			#   UnEditable; 2 = Don't Quote Subject, Editable.
$use_time = 1;		# 1 = YES; 0 = NO

# Done
###########################################################################

# Get the Data Number
&get_number;

# Get Form Information
&parse_form;

# Put items into nice variables
&get_variables;

# View Before Posting
if ($FORM{'action'} ne "post") {
  &view_post
}

# Open the new file and write information to it.
&new_file;

# Open the Main WWWBoard File to add link
&main_page;

# Now Add Thread to Individual Pages
if ($num_followups >= 1) {
   &thread_pages;
}

# Return the user HTML
&return_html;

# Increment Number
&increment_num;

############################
# Get Data Number Subroutine

sub get_number {
   open(NUMBER,"$basedir/$datafile");
   $num = <NUMBER>;
   close(NUMBER);
   if ($num == 99999)  {
      $num = "1";
   }
   else {
      $num++;
   }
}

#######################
# Parse Form Subroutine

sub parse_form {

   # Get the input
   read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

   # Split the name-value pairs
   @pairs = split(/&/, $buffer);

   foreach $pair (@pairs) {
      ($name, $value) = split(/=/, $pair);

      # Un-Webify plus signs and %-encoding
      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
      $value =~ s/<!--(.|\n)*-->//g;

      if ($allow_html != 1) {
         $value =~ s/<([^>]|\n)*>//g;
      }
      else {
         unless ($name eq 'body') {
	    $value =~ s/<([^>]|\n)*>//g;
         }
      }

      $FORM{$name} = $value;
   }

}

###############
# Get Variables

sub get_variables {

   if ($FORM{'followup'}) {
      $followup = "1";
      @followup_num = split(/,/,$FORM{'followup'});
      $num_followups = @followups = @followup_num;
      $last_message = pop(@followups);
      $origdate = "$FORM{'origdate'}";
      $origname = "$FORM{'origname'}";
      $origsubject = "$FORM{'origsubject'}";
   }
   else {
      $followup = "0";
   }

   if ($FORM{'name'}) {
      $name = "$FORM{'name'}";
      $name =~ s/"//g;
      $name =~ s/<//g;
      $name =~ s/>//g;
      $name =~ s/\&//g;
   }
   else {
      &error(no_name);
   }

   if ($FORM{'email'} =~ /.*\@.*\..*/) {
      $email = "$FORM{'email'}";
   }

   if ($FORM{'subject'}) {
      $subject = "$FORM{'subject'}";
      $subject =~ s/\&/\&amp\;/g;
      $subject =~ s/"/\&quot\;/g;
   }
   else {
      &error(no_subject);
   }

   if ($FORM{'body'}) {
      $body = "$FORM{'body'}";
      $body =~ s/\cM//g;
      $body =~ s/\n\n/<p>/g;
      $body =~ s/\n/<br>/g;

      $body =~ s/&lt;/</g; 
      $body =~ s/&gt;/>/g; 
      $body =~ s/&quot;/"/g;
   }
   else {
      &error(no_body);
   }

   $hidden_body = "$body";
   $hidden_body =~ s/</&lt;/g;
   $hidden_body =~ s/>/&gt;/g;
   $hidden_body =~ s/"/&quot;/g;

   ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

   if ($sec < 10) {
      $sec = "0$sec";
   }
   if ($min < 10) {
      $min = "0$min";
   }
   if ($hour < 10) {
      $hour = "0$hour";
   }
   if ($mon < 10) {
      $mon = "0$mon";
   }
   if ($mday < 10) {
      $mday = "0$mday";
   }
   $month = ($mon + 1);

   @months = ("January","February","March","April","May","June","July","August","September","October","November","December");

   if ($year > 99) { 
       $year = $year - 100;
        if ($year < 10) {
	    $year = "0$year";
	}
       $long_date = "$months[$mon] $mday, 20$year at $hour\:$min\:$sec";
   }
   else {
       $long_date = "$months[$mon] $mday, 19$year at $hour\:$min\:$sec";
   }

   if ($use_time == 1) {
      $date = "$month/$mday/$year $hour\:$min\:$sec";
   }
   else {
      $date = "$month/$mday/$year";
   }
   chop($date) if ($date =~ /\n$/);
}      

#####################
# View Post Subroutine

sub view_post {
   print "Content-type: text/html\n\n";
   print "<html><head><title>Preview Post</title></head>\n";
   print "<center><h1>Preview Post</h1></center>\n";
   print "<p><hr size=2><p>\n";
   print "The following information will be added to the message board. <b>Use your browser's BACK button to make changes.</b><p>\n";
   print "<b>Name:</b> $name<br>\n";
   print "<b>E-Mail:</b> $email<br>\n";
   print "<b>Subject:</b> $subject<br>\n";
   print "<p><table border bgcolor=\"#FFFFFF\" width=\"100%\" cellpadding=5 cellspacing=0><td>$body</td></table>\n";
   print "<form method=POST action=\"$cgi_url\">\n";
   print "<input type=hidden name=\"action\" value=\"post\">\n";
   print "<input type=hidden name=\"name\" value=\"$name\">\n";
   print "<input type=hidden name=\"email\" value=\"$email\">\n";
   print "<input type=hidden name=\"subject\" value=\"$subject\">\n";
   print "<input type=hidden name=\"body\" value=\"$hidden_body\">\n";
   print "<input type=hidden name=\"url\" value=\"$FORM{'url'}\">\n";
   print "<input type=hidden name=\"url_title\" value=\"$FORM{'url_title'}\">\n";
   print "<input type=hidden name=\"img\" value=\"$FORM{'img'}\">\n";
   print "<input type=hidden name=\"origsubject\" value=\"$FORM{'origsubject'}\">\n";
   print "<input type=hidden name=\"origname\" value=\"$FORM{'origname'}\">\n";
   print "<input type=hidden name=\"origemail\" value=\"$FORM{'origemail'}\">\n";
   print "<input type=hidden name=\"origdate\" value=\"$FORM{'origdate'}\">\n";
   print "<input type=hidden name=\"followup\" value=\"$FORM{'followup'}\">\n";
   print "<hr size=2>\n";
   print "<p><input type=submit value=\"Post\">\n";
   print "</body></html>\n";
   exit;
}

#####################
# New File Subroutine

sub new_file {

   open(NEWFILE,">$basedir/$mesgdir/$num\.$ext") || die $!;
   print NEWFILE "<html>\n";
   print NEWFILE "  <head>\n";
   print NEWFILE "    <title>$subject</title>\n";
   print NEWFILE "  </head>\n";
   print NEWFILE "  <body>\n";
   print NEWFILE "    <center>\n";
   print NEWFILE "      <h1>$subject</h1>\n";
   print NEWFILE "    </center>\n";
   print NEWFILE "<hr size=2>\n";
   if ($show_hlp == 1) {
      print NEWFILE "<center>[ <a href=\"#followups\">Replies</a> ] [ <a href=\"#postfp\">Post Reply</a> ] [ <a href=\"$baseurl/$mesgfile\">$title</a> ] [ <a href=\"$baseurl/$hlpfile\">Help</a> ]</center>\n";
   }
   else {
      print NEWFILE "<center>[ <a href=\"#followups\">Replies</a> ] [ <a href=\"#postfp\">Post Reply</a> ] [ <a href=\"$baseurl/$mesgfile\">$title</a> ]</center>\n";
   }
   print NEWFILE "<hr size=2><p>\n";

   print NEWFILE "Posted by ";

   if ($email) {
      print NEWFILE "<a href=\"mailto:$email\">$name</a> on $long_date<p>\n";
   }
   else {
      print NEWFILE "$name on $long_date<p>\n";
   }

   if ($followup == 1) {
      print NEWFILE "In Reply to <a href=\"$last_message\.$ext\">$origsubject</a> posted by ";

      if ($origemail) {
         print NEWFILE "<a href=\"$origemail\">$origname</a> on $origdate<p>\n";
      }
      else {
         print NEWFILE "$origname on $origdate<p>\n";
      }
   }

   print NEWFILE "<table border bgcolor=\"#FFFFFF\" width=\"100%\" cellpadding=5 cellspacing=0><td>$body</td></table>\n";
   print NEWFILE "<br>\n";
   print NEWFILE "<a name=\"followups\">Replies:</a><br>\n";
   print NEWFILE "<ul><!--insert: $num-->\n";
   print NEWFILE "</ul><!--end: $num-->\n";
   print NEWFILE "<hr size=2><p>\n";
   print NEWFILE "<a name=\"postfp\"><center><h2>Post Reply</h2></center></a><p>\n";
   print NEWFILE "<form method=POST action=\"$cgi_url\">\n";
   print NEWFILE "<input type=hidden name=\"followup\" value=\"";
   if ($followup == 1) {
      foreach $followup_num (@followup_num) {
         print NEWFILE "$followup_num,";
      }
   }
   print NEWFILE "$num\">\n";
   print NEWFILE "<input type=hidden name=\"origname\" value=\"$name\">\n";
   if ($email) {
      print NEWFILE "<input type=hidden name=\"origemail\" value=\"$email\">\n";
   }
   print NEWFILE "<input type=hidden name=\"origsubject\" value=\"$subject\">\n";
   print NEWFILE "<input type=hidden name=\"origdate\" value=\"$long_date\">\n";
   print NEWFILE "Name: <input type=text name=\"name\" size=50><br>\n";
   print NEWFILE "E-Mail: <input type=text name=\"email\" size=50><p>\n";
   if ($subject_line == 1) {
      if ($subject_line =~ /^Re:/) {
         print NEWFILE "<input type=hidden name=\"subject\" value=\"$subject\">\n";
         print NEWFILE "Subject: <b>$subject</b><p>\n";
      }
      else {
         print NEWFILE "<input type=hidden name=\"subject\" value=\"Re: $subject\">\n";
         print NEWFILE "Subject: <b>Re: $subject</b><p>\n";
      }
   } 
   elsif ($subject_line == 2) {
      print NEWFILE "Subject: <input type=text name=\"subject\" size=50><p>\n";
   }
   else {
      if ($subject =~ /^Re:/) {
         print NEWFILE "Subject: <input type=text name=\"subject\"value=\"$subject\" size=50><p>\n";
      }
      else {
         print NEWFILE "Subject: <input type=text name=\"subject\" value=\"Re: $subject\" size=50><p>\n";
      }
   }
   print NEWFILE "Comments:<br>\n";
   print NEWFILE "<textarea name=\"body\" wrap=\"virtual\" COLS=50 ROWS=10>\n";
   if ($quote_text == 1) {
      @chunks_of_body = split(/\&lt\;p\&gt\;/,$hidden_body);
      foreach $chunk_of_body (@chunks_of_body) {
         @lines_of_body = split(/\&lt\;br\&gt\;/,$chunk_of_body);
         foreach $line_of_body (@lines_of_body) {
            print NEWFILE ": $line_of_body\n";
         }
         print NEWFILE "\n";
      }
   }
   print NEWFILE "</textarea>\n";
   print NEWFILE "<p>\n";
   print NEWFILE "<input type=submit value=\"Preview\"> <input type=reset value=\"Clear\">\n";
   print NEWFILE "<p><hr size=2>\n";
   print NEWFILE "</body></html>\n";
   close(NEWFILE);
}

###############################
# Main WWW
#Board Page Subroutine

sub main_page {
   open(MAIN,"$basedir/$mesgfile") || die $!;
   @main = <MAIN>;
   close(MAIN);

   open(MAIN,">$basedir/$mesgfile") || die $!;
   if ($followup == 0) {
      foreach $main_line (@main) {
         if ($main_line =~ /<!--begin-->/) {
            print MAIN "<!--begin-->\n";
	    print MAIN "<!--top: $num--><li><a href=\"$mesgdir/$num\.$ext\">$subject</a> - <b>$name</b> <i>$date</i>\n";
            print MAIN "(<!--responses: $num-->0)\n";
            print MAIN "<ul><!--insert: $num-->\n";
            print MAIN "</ul><!--end: $num-->\n";
         }
         else {
            print MAIN "$main_line";
         }
      }
   }
   else {
      foreach $main_line (@main) {
	 $work = 0;
         if ($main_line =~ /<ul><!--insert: $last_message-->/) {
            print MAIN "<ul><!--insert: $last_message-->\n";
            print MAIN "<!--top: $num--><li><a href=\"$mesgdir/$num\.$ext\">$subject</a> - <b>$name</b> <i>$date</i>\n";
            print MAIN "(<!--responses: $num-->0)\n";
            print MAIN "<ul><!--insert: $num-->\n";
            print MAIN "</ul><!--end: $num-->\n";
         }
         elsif ($main_line =~ /\(<!--responses: (.*)-->(.*)\)/) {
            $response_num = $1;
            $num_responses = $2;
            $num_responses++;
            foreach $followup_num (@followup_num) {
               if ($followup_num == $response_num) {
                  print MAIN "(<!--responses: $followup_num-->$num_responses)\n";
		  $work = 1;
               }
            }
            if ($work != 1) {
               print MAIN "$main_line";
            }
         }
         else {
            print MAIN "$main_line";
         }
      }
   }
   close(MAIN);
}

############################################
# Add Followup Threading to Individual Pages

sub thread_pages {
   foreach $followup_num (@followup_num) {
      open(FOLLOWUP,"$basedir/$mesgdir/$followup_num\.$ext");
      @followup_lines = <FOLLOWUP>;
      close(FOLLOWUP);

      open(FOLLOWUP,">$basedir/$mesgdir/$followup_num\.$ext");
      foreach $followup_line (@followup_lines) {
         $work = 0;
         if ($followup_line =~ /<ul><!--insert: $last_message-->/) {
	    print FOLLOWUP "<ul><!--insert: $last_message-->\n";
            print FOLLOWUP "<!--top: $num--><li><a href=\"$num\.$ext\">$subject</a> <b>$name</b> <i>$date</i>\n";
            print FOLLOWUP "(<!--responses: $num-->0)\n";
            print FOLLOWUP "<ul><!--insert: $num-->\n";
            print FOLLOWUP "</ul><!--end: $num-->\n";
         }
         elsif ($followup_line =~ /\(<!--responses: (.*)-->(.*)\)/) {
            $response_num = $1;
            $num_responses = $2;
            $num_responses++;
            foreach $followup_num (@followup_num) {
               if ($followup_num == $response_num) {
                  print FOLLOWUP "(<!--responses: $followup_num-->$num_responses)\n";
                  $work = 1;
               }
            }
            if ($work != 1) {
               print FOLLOWUP "$followup_line";
            }
         }
         else {
            print FOLLOWUP "$followup_line";
         }
      }
      close(FOLLOWUP);
   }
}

sub return_html {
   print "Content-type: text/html\n\n";
   print "<html><head><title>Message Added</title></head>\n";
   print "<body><center><h1>Message Added</h1></center>\n";
   print "<p><hr size=2>\n";
   print "<center>[ <a href=\"$baseurl/$mesgdir/$num\.$ext\">Go to Your Message</a> ] [ <a href=\"$baseurl/$mesgfile\">$title</a> ]</center>\n";
   print "<hr size=2><p>\n";
   print "The following information was added to the message board at $date<p>\n";
   print "<b>Name:</b> $name<br>\n";
   print "<b>E-Mail:</b> $email<br>\n";
   print "<b>Subject:</b> $subject<br>\n";
   print "<p><table border bgcolor=\"#FFFFFF\" width=\"100%\" cellpadding=5 cellspacing=0><td>$body</td></table>\n";
   print "<p><hr size=2>\n";
   print "</body></html>\n";
}

sub increment_num {
   open(NUM,">$basedir/$datafile") || die $!;
   print NUM "$num";
   close(NUM);
}

sub error {
   $error = $_[0];

   print "Content-type: text/html\n\n";

   if ($error eq 'no_name') {
      print "<html><head><title>ERROR: No Name</title></head>\n";
      print "<body><center><h1>ERROR: No Name</h1></center>\n";
      print "You forgot to fill in the 'Name' field in your posting.  Correct it below and re-submit.  The necessary fields are: Name, Subject and Message.<p><hr size=2><p>\n";
      &rest_of_form;
   }
   elsif ($error eq 'no_subject') {
      print "<html><head><title>ERROR: No Subject</title></head>\n";
      print "<body><center><h1>ERROR: No Subject</h1></center>\n";
      print "You forgot to fill in the 'Subject' field in your posting.  Correct it below and re-submit.  The necessary fields are: Name, Subject and Message.<p><hr size=2><p>\n";
      &rest_of_form;
   }
   elsif ($error eq 'no_body') {
      print "<html><head><title>ERROR: No Message</title></head>\n";
      print "<body><center><h1>ERROR: No Message</h1></center>\n";
      print "You forgot to fill in the 'Message' field in your posting.  Correct it below and re-submit.  The necessary fields are: Name, Subject and Message.<p><hr size=2><p>\n";
      &rest_of_form;
   }
   else {
      print "ERROR!  Undefined.\n";
   }
   exit;
}

sub rest_of_form {
   print "<form method=POST action=\"$cgi_url\">\n";

   if ($followup == 1) {
      print "<input type=hidden name=\"origsubject\" value=\"$FORM{'origsubject'}\">\n";
      print "<input type=hidden name=\"origname\" value=\"$FORM{'origname'}\">\n";
      print "<input type=hidden name=\"origemail\" value=\"$FORM{'origemail'}\">\n";
      print "<input type=hidden name=\"origdate\" value=\"$FORM{'origdate'}\">\n";
      print "<input type=hidden name=\"followup\" value=\"$FORM{'followup'}\">\n";
   }
   print "Name: <input type=text name=\"name\" value=\"$FORM{'name'}\" size=50><br>\n";
   print "E-Mail: <input type=text name=\"email\" value=\"$FORM{'email'}\" size=50><p>\n";
   if ($subject_line == 1) {
      print "<input type=hidden name=\"subject\" value=\"$FORM{'subject'}\">\n";
      print "Subject: <b>$FORM{'subject'}</b><p>\n";
   } 
   else {
      print "Subject: <input type=text name=\"subject\" value=\"$FORM{'subject'}\" size=50><p>\n";
   }
   print "Message:<br>\n";
   print "<textarea name=\"body\" wrap=\"virtual\" COLS=50 ROWS=10>\n";
   $FORM{'body'} =~ s/</&lt;/g;
   $FORM{'body'} =~ s/>/&gt;/g;
   $FORM{'body'} =~ s/"/&quot;/g;
   print "$FORM{'body'}\n";
   print "</textarea><p>\n";
   print "<input type=submit value=\"Preview\"> <input type=reset value=\"Clear\">\n";
   print "</form>\n";
   print "<br><hr size=2>\n";
   print "</body></html>\n";
}
